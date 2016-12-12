#!/bin/bash

cluster=quarteto-fantastico

# file=(base-basica.csv)
# file=(bolsa-familia-2016-janeiro.csv)
file=(bolsa-familia-2016-total.csv bolsa-familia-2016-janeiro.csv)

javac -classpath `yarn classpath` -d . BolsaFamiliaDriver.java BolsaFamiliaMapper.java BolsaFamiliaReducer.java
jar cfm BolsaFamilia.jar Manifest.txt BolsaFamilia/*.class

for j in $(seq -w 01 03)
do
	for i in ${file[@]}
	do
	    output=04-out-$cluster-hadoop-$i
	    hdfs dfs -rm -r /$output
            beginTime=$(date +"%s%3N")
	    hadoop jar BolsaFamilia.jar /$i /$output &> $output-$j.logs
 	    endTime=$(date +"%s%3N")
            echo "Tempo gasto na tarefa em milissegundos" >> $output-$j.logs
            echo "Tempo: $(($endTime - $beginTime))" >> $output-$j.logs
	    hdfs dfs -copyToLocal /$output/part-* .
	    echo -e "UF\tQUANTIDADE" > $output
	    cat part-* | sort >> $output
	    rm -rf part-*
	done
done
zip -r $cluster-hadoop-qdePorUF.zip 04-out*
