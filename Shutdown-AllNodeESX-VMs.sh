#!/bin/bash
#prima connessione al nodo esx02 e inventario delle virtual machines sul nodo
ssh root@192.168.55.134 'esxcli vm process list;' > '/home/samuele/Desktop/ssh script/vms.txt'
#----------------------------------------------------------------------------
# rilevo quante VMs sono in totale sul nodo, questo servirà nel ciclo di spengimento per sapere quante volte effettuare il ciclo.
length=$(cat '/home/samuele/Desktop/ssh script/vms.txt' | grep -o -i 'World ID' | wc -l)
#----------------------------------------------------------------------------
# Da riga 9 a 15, si filtra escludendo nomi e dati inutili, così da ottenere tutti i World ID che sono passati nel ciclo di spengimento
array=$(cat '/home/samuele/Desktop/ssh script/vms.txt' | grep 'World ID' )
for each in "${array[@]}"
do
  echo "$each" | awk '{print $3}' > '/home/samuele/Desktop/ssh script/vms.txt'
done
IDtemp=$(cat '/home/samuele/Desktop/ssh script/vms.txt' )
#parte il ciclo di spengimento e trasformo gli IDs in un singolo ID per volta per ogni iterazione del ciclo
for (( i = 1; i <= $length; i++ )); do
  #statements
   ID=$(echo $IDtemp | cut -d ' ' -f $i)
   ssh root@192.168.55.134 "esxcli vm process kill --type soft --world-id $ID"
done
# E' consigliabile applicare un certificato SSH pubblico che non chiede sempre la password perchè per ogni comando ssh dovrà essere inserita manualmente la password
#fine dello script - È RELATIVO SOLO AL NODO 2 ESX , VA COPIATO ANCHE PER IL NODO 1 CAMBIANDO I RELATIVI DATI DI CONNESSIONE
