#!/bin/bash

cluster=tartarugas-ninja

#file=(base-basica.csv)
#file=(bolsa-familia-2011-total.csv bolsa-familia-2016-total.csv bolsa-familia-2016-janeiro.csv)
file=(bolsa-familia-2016-total.csv)
main=QuantidadePorUF.pig

for j in $(seq -w 01 01)
do
    for i in ${file[@]}
    do
        output=out-$cluster-pig-$i
        beginTime=$(date +"%s%3N")
        pig -d OFF -4 nolog.conf -param FILE=\'\/$i\' $main 1> $output-$j.logs
        endTime=$(date +"%s%3N")
        echo "Tempo gasto na tarefa em milissegundos" >> $output-$j.logs
        echo "Tempo: $(($endTime - $beginTime))" >> $output-$j.logs
    done
done

zip $cluster-pig-qdePorUF.zip out*

echo " [+] Done."
