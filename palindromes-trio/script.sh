#!/bin/bash
limit=1000000000
fileinput="input-palin"

echo "4 9 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "4 8 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "4 8 13" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "4 7 8" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "4 13 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "4 11 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "3 7 9" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "3 5 12" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 8 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 8 14" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 8 12" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 4 8 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 8 12" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 4 8" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 4 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput

echo "2 12 16" > $fileinput
echo "$limit" >> $fileinput 
time python3.6 palin-sequence.py < $fileinput
