#!/bin/sh
echo "\n> environment:"
echo "SPARTACUS_APP_SERVER: $SPARTACUS_APP_SERVER"
echo "SPARTACUS_APP_BROWSER: $SPARTACUS_APP_BROWSER"
echo "SPARTACUS_OCC_ENDPOINT: $SPARTACUS_OCC_ENDPOINT"

echo "\n> prepare container:"
 if [ -z "$SPARTACUS_OCC_ENDPOINT" ]
    then
        echo "replace meta [occ-backend-base-url]: nothing to do"
    else
        echo "replace meta [occ-backend-base-url] with [$SPARTACUS_OCC_ENDPOINT] in index.html"
        sed -i'.bak' "s|<meta name=\"occ-backend-base-url\".*>|<meta name=\"occ-backend-base-url\" content=\"$SPARTACUS_OCC_ENDPOINT\">|g" $SPARTACUS_APP_BROWSER/index.html
fi

MAIN_JS="$SPARTACUS_APP_SERVER/main.js"
echo "\n> starting node server (SSR): $MAIN_JS"
if [ "$SPARTACUS_SSR_SKIP_VALIDATION" = "true" ]
    then
        echo "running node server without certificate validation (security) and PM2 (performance)"
        NODE_TLS_REJECT_UNAUTHORIZED=0 node "$SPARTACUS_APP_SERVER/main.js"
    else
        PM2_ARGS="--no-daemon"
        # Max Memory
        if [ ! -z "$SPARTACUS_PM2_MAX_MEMORY_RESTART" ] ; then
            PM2_ARGS="$PM2_ARGS --max-memory-restart $SPARTACUS_PM2_MAX_MEMORY_RESTART"
        fi
        # Cluster Mode
        if [ ! -z "$SPARTACUS_PM2_INSTANCES" ] ; then
            PM2_ARGS="$PM2_ARGS -i $SPARTACUS_PM2_INSTANCES"
        fi
        # Extra Option
        if [ ! -z "$SPARTACUS_PM2_NODE_ARGS" ] ; then
            PM2_ARGS="$PM2_ARGS -- $SPARTACUS_PM2_NODE_ARGS"
        fi
        echo "running PM2 server: $PM2_ARGS"
        pm2 start $MAIN_JS $PM2_ARGS
fi
