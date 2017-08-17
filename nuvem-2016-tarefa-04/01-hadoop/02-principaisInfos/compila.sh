#!/bin/bash

file=base-basica.csv
output=output-$file

javac -classpath `yarn classpath` -d . BolsaFamiliaDriver.java BolsaFamiliaMapper.java BolsaFamiliaReducer.java
jar cfm BolsaFamilia.jar Manifest.txt BolsaFamilia/*.class
