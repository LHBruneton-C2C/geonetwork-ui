#!/usr/bin/env bash

DIST_DEMO_PATH=dist/demo/
DIST_WC_PATH=${DIST_DEMO_PATH}webcomponents/
APP_NAME=${1}

echo '-- Build Geonetwork Web Components'
ng build --prod --output-hashing=none --output-path=${DIST_WC_PATH} gn-wc

echo '-- Publish html page for Web Component' ${APP_NAME}
mkdir -p $DIST_WC_PATH
cat ${DIST_WC_PATH}{runtime,polyfills,main}.js > $DIST_WC_PATH'gn-wc.js'
rm -f ${DIST_WC_PATH}main.js
rm -f ${DIST_WC_PATH}polyfills.js
rm -f ${DIST_WC_PATH}runtime.js
rm -f ${DIST_WC_PATH}styles.css

sampleLinks=""
for c in webcomponents/src/app/components/gn-* ; do
  echo "-- Copy HTML sample for:" `basename $c`
  fileName=`basename $c`".sample.html"
  cp $c/$fileName $DIST_WC_PATH
  sampleLinks+="<a href='"$fileName"'>"`basename $c`"</a>"
done

echo "-- Copy demo pages"
mkdir -p ${DIST_DEMO_PATH}pages
cp -R demo/* ${DIST_DEMO_PATH}pages


if [ ${1} ] && [ ${1} = "--serve" ]
then
  ./node_modules/.bin/http-server $DIST_DEMO_PATH -p 8001 --gzip
fi
