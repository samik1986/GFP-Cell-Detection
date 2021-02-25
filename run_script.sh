#!/bin/bash
# Use the 'sh run_script.sh Hua150'
cd GFP_Cell_Detection
matlab -nodesktop -nosplash -r "main_bam('$1/'); exit;"
