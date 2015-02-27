#!/bin/bash

gradle fatJar &&
./import.sh &&
ceylon compile &&
./buildWar.sh

