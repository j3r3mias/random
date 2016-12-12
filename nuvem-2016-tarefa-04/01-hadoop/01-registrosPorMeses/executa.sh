#!/bin/bash

# file=(base-basica.csv)
file=(bolsa-familia-2011-total.csv bolsa-familia-2016-total.csv)

for j in $(seq -w 01 03)
do
	for i in ${file[@]}
	do
		output=01-output-$i
		javac -classpath `yarn classpath` -d . BolsaFamiliaDriver.java BolsaFamiliaMapper.java BolsaFamiliaReducer.java
		jar cfm BolsaFamilia.jar Manifest.txt BolsaFamilia/*.class
		hdfs dfs -rm -r /$output
		hadoop jar BolsaFamilia.jar /$i /$output &> $output-$j.logs
		hdfs dfs -copyToLocal /$output/part-* .
		echo -e "Mes\tQuantidade" > $output
		cat part-* | sort >> $output
		rm -rf part-*
	done
done
