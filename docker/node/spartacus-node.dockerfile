# Stage 1 - Resolve Dependencies
FROM --platform=linux/amd64 node:lts-bullseye-slim as spartacus-modules
WORKDIR /opt/jsapp
COPY .npmrc .
COPY package.json .
RUN yarn install

# Stage 2 - Build SSR
FROM --platform=linux/amd64 node:lts-bullseye-slim as spartacus-build-ssr
WORKDIR /opt/jsapp
COPY --from=spartacus-modules /opt/jsapp/node_modules ./node_modules
COPY . .
RUN yarn build:ssr

# Stage 3 - Serve SSR
FROM --platform=linux/amd64 node:lts-bullseye-slim 
WORKDIR /opt/jsapp
COPY --from=spartacus-build-ssr /opt/jsapp/dist ./dist
COPY ./seh/docker/node/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
RUN npm install pm2@latest -g

# Environment
ARG SPARTACUS_APP_NAME
ENV SPARTACUS_APP_NAME=${SPARTACUS_APP_NAME}
ENV SPARTACUS_APP_BROWSER="/opt/jsapp/dist/${SPARTACUS_APP_NAME}/browser"
ENV SPARTACUS_APP_SERVER="/opt/jsapp/dist/${SPARTACUS_APP_NAME}/server"
ENV SPARTACUS_PM2_MAX_MEMORY_RESTART=
ENV SPARTACUS_PM2_NODE_ARGS=
ENV SPARTACUS_PM2_INSTANCES=
ENV SPARTACUS_OCC_ENDPOINT=

# Expose
EXPOSE 4000

# EntryPoint
ENTRYPOINT ["./entrypoint.sh"]