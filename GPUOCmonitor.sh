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
				sudo nvidia-smi -pl 300
                sudo nvidia-smi -rgc
                sudo DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/:0 nvidia-settings -c :0 -a '[gpu:0]/GPUGraphicsClockOffset[4]=-100' -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=2500'                
                
        fi

        if [ "$running" -eq 0  ] && [ "$OCset" -eq 1 ]
        then
                echo "nbminer not running and mem oc is not set"
                let OCset=0
				sudo nvidia-smi -pl 350
                sudo nvidia-smi --lock-gpu-clocks=100,1740
                sudo DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/:0 nvidia-settings -c :0 -a '[gpu:0]/GPUGraphicsClockOffset[4]=0' -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=0'
                
        fi


        sleep 10
done