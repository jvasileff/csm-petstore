#!/bin/bash

ceylon import-jar \
  --out=./modules-deps \
  --force \
  --descriptor=fat.jar.deps.properties \
  fat.jar.deps/1.0.0 \
  build/libs/sandbox-ceylon-snap-all.jar
