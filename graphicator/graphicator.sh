#!/bin/bash

dir="data"
list=$(ls $dir/*sem*)

for i in ${list[@]}
do
    withCheck=${i/sem/com}
    if [ -f $withCheck ]
    then
        output=$(echo $i | cut -d _ -f 2)
        echo "Arquivo: $output - $i"
        gnuplot <<- EOF
            set output "$output.png"
            set term png
            set multiplot
            set xlabel "Step"        
            set ylabel "Tempo (ms)"
            # set ytics 0, 100  
            set title "Execução com ${output} agentes"        
            # set nokey
            set key left top
            plot "$i" with lines lt 2 title "Sem checkpoint",  "$withCheck" with lines lt 4 title "Com checkpoint"
EOF
    fi
done
