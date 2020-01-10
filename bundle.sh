#!/bin/bash
cd js/front
npm run build
cd ../..
rm -rf ./js/server/public/
mkdir ./js/server/public
cp -a ./js/front/dist/. ./js/server/public/
cp -R ./js/nav ./js/server/public/