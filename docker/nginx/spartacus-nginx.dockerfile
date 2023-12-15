# # Stage 1 - Build Spartacus
ARG SPARTACUS_SSR_IMAGE
FROM --platform=linux/amd64 ${SPARTACUS_SSR_IMAGE} as spartacus-ssr

# Stage 2 - Serve Spartacus 
FROM --platform=linux/amd64 nginx:stable-alpine-slim
ARG SPARTACUS_APP_NAME
WORKDIR /opt/jsapp
COPY --from=spartacus-ssr /opt/jsapp/dist/$SPARTACUS_APP_NAME/browser ./html
COPY seh/docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY seh/docker/nginx/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENV SPARTACUS_APP_BROWSER="/opt/jsapp/html"
ENV SPARTACUS_OCC_ENDPOINT=""
ENTRYPOINT [ "./entrypoint.sh" ]

EXPOSE 8080
EXPOSE 8081