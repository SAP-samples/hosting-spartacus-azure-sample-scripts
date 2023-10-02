#!/bin/sh
echo "\n> environment:"
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

echo "\n> starting nginx:"
exec /usr/sbin/nginx -g 'daemon off;'