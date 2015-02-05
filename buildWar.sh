#!/bin/bash

ceylon war \
  --rep modules-deps \
  --name csmPetstore.war \
  --out build \
  --resource-root webapp \
  --exclude-module javax.servlet \
  com.vasileff.csmpetstore

#  --rep aether \
