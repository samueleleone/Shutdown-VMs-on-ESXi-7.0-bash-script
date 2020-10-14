#!/bin/bash
# A bash script to shutdown every virtual machines on esx VMware node coded from Samuele Leone
#first of all, connecting to node and collecting virtual machines on that node esx in VMware infrastructure
ssh user@ip_of_node 'esxcli vm process list;' > '/home/user/Desktop/ssh script/vms.txt'
#----------------------------------------------------------------------------
# counting vms on that node, that number it's useful for shutdown iteration 
length=$(cat '/home/user/Desktop/ssh script/vms.txt' | grep -o -i 'World ID' | wc -l)
#----------------------------------------------------------------------------
# Here from row 9 to 15 i filter every kind of data that's useless for my scope. I just want World ID to shutdown virtual machines.
array=$(cat '/home/user/Desktop/ssh script/vms.txt' | grep 'World ID' )
for each in "${array[@]}"
do
  echo "$each" | awk '{print $3}' > '/home/user/Desktop/ssh script/vms.txt'
done
IDtemp=$(cat '/home/user/Desktop/ssh script/vms.txt' )
# Here loop to shutdown every vm from his world id 
for (( i = 1; i <= $length; i++ )); do
  #statements
   ID=$(echo $IDtemp | cut -d ' ' -f $i)
   ssh root@192.168.55.134 "esxcli vm process kill --type soft --world-id $ID"
done
# Tips on that script: using a public certificate could make it fastest to run it, otherwise every run of the script will ask you password.
# That's all , obviously here i consider as my target just one esx node, if you wanna to shutdown vms on other node you have to connect to every node in infrastructure.
