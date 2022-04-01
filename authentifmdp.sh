#!/bin/bash

file="/etc/ssh/sshd_config"
# file="test"
allow="PasswordAuthentication yes"
notAllow="PasswordAuthentication no"

##########################################
## Fonction autorise                     #
##########################################

function autorise() {
        change=$(grep -r "PasswordAuthentication " $file)
        countline=$(grep -r "PasswordAuthentication " $file | wc -l)

        if [ -z "$change" ]
        then
                echo "PasswordAuthentication yes" >> $file
                echo -e "le paramètre a été rajouté au fichier de configuration"
        else
                grep -r "PasswordAuthentication " $file | while IFS= read -r line; do sed -i "/""$line""/,+d" $file ; done
                echo "PasswordAuthentication yes" >> $file
                echo -e "le fichier a été modifié pour autoriser l'authentification par mot de passe"
        fi
        }

##########################################
## Fonction n'autorise pas               #
##########################################

function notAutorise() {
        change=$(grep -r "PasswordAuthentication " $file)
        countline=$(grep -r "PasswordAuthentication " $file | wc -l)

        if [ -z "$change" ]
        then
              echo "PasswordAuthentication no" >> $file
              echo "le pramètre a été rajouté au fichier de configuration"
        else
              grep -r "PasswordAuthentication " $file | while IFS= read -r line; do sed -i "/""$line""/,+d" $file ; done
              echo "PasswordAuthentication no" >> $file
              echo "le fichier a été modifié pour ne pas autoriser l'authentification par mot de passe"
        fi
}

##########################################
## Menu                                  #
##########################################

function menu(){
while [ $reponse != "y" ] && [ $reponse != "n" ]
do
echo "dsl vous n'avez pas donné la bonne reponse. Répondez par 'y' ou 'n'"

echo -n "
Voulez-vous mettre l'authentification par mot de passe:
"
read reponse

done
}




#########################################
## Debut du script                      #
#########################################

echo -n "
Voulez-vous mettre l'authentification par mot de passe:
"
read reponse

menu

if [ $reponse = "y" ]
then
        autorise
else
        notAutorise
fi

/etc/init.d/ssh restart
