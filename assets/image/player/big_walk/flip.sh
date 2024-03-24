#!/bin/bash
for f in *.png; do
   new="${f%%.png}.png"
   echo convert "$f" -flop "./flip/$new"
done
