#!/bin/bash

ceylon import-jar \
  --out=./modules-deps \
  --force \
  --descriptor=csmpetstoredeps.properties \
  com.vasileff.csmpetstoredeps/1.0.0 \
  build/libs/csm-petstore-all.jar
