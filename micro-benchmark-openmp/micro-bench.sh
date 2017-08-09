#!/bin/bash

if (( $EUID != 0 ))
then
    echo " [!] Please, execute as root!"
    exit
fi

filename="openmp-bench.cpp"
exe="prog-bench"
output=$(hostname)-report.log

touch $output

for i in $(seq 0 1 3)
do
    echo " [+] Tests with flag -O$i"
    echo " [+] Using flag -O$i" >> $output
    g++ -o $exe $filename -fopenmp -std=c++14 -O$i
    perf stat -r 10 -d ./$exe &>> $output
    rm $exe
    echo ""
done

