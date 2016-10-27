#!/bin/bash

programa=solver.cpp
arq=tempos.csv
exe=executavel

# Compilação
# $(g++-6 -o $exe $programa -fopenmp -lcrypto)
# icpc -o $exe $programa -fopenmp -lcrypto

# Criando arquivos
echo "threads segundos speedup" > $arq

# Com cancelamento
export OMP_CANCELLATION=true

export OMP_NUM_THREADS=1
tempoAntes=$(date +"%s")
./$exe
tempoDepois=$(date +"%s")
tempoSerial=$(echo "$tempoDepois - $tempoAntes" | bc -l)

speedup=$(echo "$tempoSerial / $tempoSerial" | bc -l)
echo "1 $tempoSerial $speedup" >> $arq

for i in `seq 2 2 16`
do
    export OMP_NUM_THREADS=$i
    tempoAntes=$(date +"%s")
    ./$exe
    tempoDepois=$(date +"%s")
    tempoParalelo=$(echo "$tempoDepois - $tempoAntes" | bc -l)
    speedup=$(echo "$tempoSerial / $tempoParalelo" | bc -l)
    echo "$i $tempoParalelo $speedup" >> $arq
done
