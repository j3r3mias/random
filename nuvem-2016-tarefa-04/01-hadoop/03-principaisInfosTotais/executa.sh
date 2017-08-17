#!/bin/bash

# file=(base-basica.csv)
# file=(bolsa-familia-2016-total.csv)
file=(bolsa-familia-2011-total.csv bolsa-familia-2016-total.csv)

javac -classpath `yarn classpath` -d . BolsaFamiliaDriver.java BolsaFamiliaMapper.java BolsaFamiliaReducer.java
jar cfm BolsaFamilia.jar Manifest.txt BolsaFamilia/*.class

for j in $(seq -w 01 03)
do
	for i in ${file[@]}
	do
	    output=03-output-$i
	    hdfs dfs -rm -r /$output
	    hadoop jar BolsaFamilia.jar /$i /$output &> $output-$j.logs
	    hdfs dfs -copyToLocal /$output/part-* .
	    echo -e "UF\tQUANTIDADE\tMEDIA\tMAIOR\tNOME MAIOR\tTOTAL" > $output
	    cat part-* | sort >> $output
	    rm -rf part-*
	done
done
zip -r 03-principaisInfos.zip 03-output*

