#!/bin/bash

file="/etc/ssh/ssh_config"
# file="test"
allow="PasswordAuthentication yes"
notAllow="PasswordAuthentication no"

##########################################
## Fonction autorise                     #
##########################################

function autorise() {
        change=$(grep -r "PasswordAuthentication" $file)
        if [ -z "$change" ]
        then
              echo "PasswordAuthentication yes" >> $file
              echo "le paramètre a été rajouté au fichier de configuration"
        else
              sed -i "s/""$change""/$allow/g" $file
              echo "le fichier a été modifié pour autoriser l'authentification par mot de passe"
        fi
        }

##########################################
## Fonction n'autorise pas               #
##########################################

function notAutorise() {
        change=$(grep -r "PasswordAuthentication" $file)
        echo "$change"
        if [ -z "$change" ]
        then
              echo "PasswordAuthentication no" >> $file
              echo "le pramètre a été rajouté au fichier de configuration"
        else
              sed -i "s/""$change""/$notAllow/g" $file
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
Voulez-vous enlever l'authentification par mot de passe:
"
read reponse

done
}




#########################################
## Debut du script                      #
#########################################

echo -n "
Voulez-vous enlever l'authentification par mot de passe:
"
read reponse

menu

if [ $reponse = "y" ]
then
        autorise
else
        notAutorise
fi
