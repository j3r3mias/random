#!/bin/bash

cluster=tartarugas-ninja

#file=(bolsa-familia-2016-total.csv)
file=(bolsa-familia-2016-janeiro.csv)
main=QuantidadePorUF
jar=target/scala-2.11/simple-project_2.11-1.0.jar

sbt clean clean-files
sbt package

for j in $(seq -w 01 01)
do
    for i in ${file[@]}
    do
        output=out-$cluster-spark-$i
        beginTime=$(date +"%s%3N")
        spark-submit --class $main $jar /$file &> $output-$j.logs
        endTime=$(date +"%s%3N")
        echo "Tempo gasto na tarefa em milissegundos" >> $output-$j.logs
        echo "Tempo: $(($endTime - $beginTime))" >> $output-$j.logs
    done
done
zip -r $cluster-spark-qdePorUF.zip out*
rm -rf project/ target/ spark-warehouse/
echo " [+] Done."
