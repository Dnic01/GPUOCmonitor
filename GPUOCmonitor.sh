#!/bin/bash

# Check if nbminer  is running and change the memory oc
# -x flag only match processes whose name (or command line if -f is
# specified) exactly match the pattern.

OCset=0
running=0
while true;do
        if pgrep -x "nbminer"  > /dev/null
        then
                echo "Running"
                let running=1
        else
                echo "Stopped"
                let running=0
        fi

        if [ "$running" -eq 1  ] && [ "$OCset" -eq 0 ]
        then
                echo "nbminer is running and mem oc is set"
                let OCset=1
				nvidia-smi -pl 320
                nvidia-smi -rgc
                /home/jzietsman/set_mem.sh 3000                
                
        fi

        if [ "$running" -eq 0  ] && [ "$OCset" -eq 1 ]
        then
                echo "nbminer not running and mem oc is not set"
                let OCset=0
				nvidia-smi -pl 350
                nvidia-smi --lock-gpu-clocks=100,1740
                /home/jzietsman/set_mem.sh 0
                
        fi


        sleep 10
done