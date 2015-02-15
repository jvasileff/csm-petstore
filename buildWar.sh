#!/bin/bash

ceylon war \
  --rep modules-deps \
  --name csmPetstore.war \
  --out build \
  --resource-root webapp \
  --exclude-module javax.servlet \
  --exclude-module org.apache.openejb:javaee-api \
  com.vasileff.csmpetstore
