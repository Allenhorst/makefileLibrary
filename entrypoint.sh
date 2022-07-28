#!/bin/bash

cd /app
echo "command:" "$1"
echo "project:" "$2"
echo "indir:" "$3"
echo "outdir:" "$4"
python3 main.py "$1" "$2" --indir "$3" --outdir "$4" 
