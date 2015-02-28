#!/bin/bash

ceylon war \
  --name csmPetstore.war \
  --out build \
  --resource-root webapp \
  --exclude-module javax.servlet \
  --exclude-module javax.servlet:javax.servlet-api \
  --exclude-module org.apache.openejb:javaee-api \
  com.vasileff.csmpetstore
