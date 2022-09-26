#!/bin/bash

file="/etc/ssh/sshd_config"
allow="PasswordAuthentication yes"
notAllow="PasswordAuthentication no"
adIp=$(ip route show | tail -1 | awk -- "{ print \$9 }")
user=$(cat /etc/passwd | grep 1000 | awk -F ':' ' {print $1}')

############
# Fonction #
############

### Fonction autorise
function autorise() {
        Aremplacer=$(grep -r "PasswordAuthentication " $file | head -1)
        dispo=$(grep -r "PasswordAuthentication " $file | wc -l)
              if [ $dispo == 0 ]
        then
                echo "PasswordAuthentication yes" >> $file
                echo -e "le paramètre a été rajouté au fichier de configuration"
        else
                sed -i "s|$Aremplacer|PasswordAuthentication yes|g" $file
                echo -e "le fichier a été modifié pour autoriser l'authentification par mot de passe"
        fi
        /etc/init.d/ssh restart
        }


### Fonction n'autorise pas
function notAutorise() {
        Aremplacer=$(grep -r "PasswordAuthentication " $file | head -1)
        dispo=$(grep -r "PasswordAuthentication " $file | wc -l)

        if [ $dispo == 0 ]
        then
              echo "PasswordAuthentication no" >> $file
              echo "le pramètre a été rajouté au fichier de configuration"
        else
              sed -i "s|$Aremplacer|PasswordAuthentication no|g" $file
              echo "le fichier a été modifié pour ne pas autoriser l'authentification par mot de passe"
        fi
        /etc/init.d/ssh restart
        }

### Fonction menu
function menu(){
        while [ $reponse != "y" ] && [ $reponse != "n" ]
        do
        echo "dsl vous n'avez pas donné la bonne reponse. Répondez par 'y' ou 'n'"

        echo -n "
        Avez vous tapé la commande ? (y/n)
        "
        read reponse

        done
        }

function changemdp(){
        echo -e "Par defaut $user n'a pas de mot de passe.\nVeuillez changer de mot de passe.\n"
        echo -n "New password of $user:
                "
                read -s pass

        echo -e "$pass\n$pass" | passwd $user
        }

### Fonction demandeTapéCommande
function demandeTaperCommande(){
        echo "
        Allez sur la machine MASTER et taper la commande suivante:
        ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$adIp
        "
        echo -n "Avez vous tapé la commande ? (y/n)"
        read reponse
        menu
        }

#########################################
## Debut du script                      #
#########################################

#
# ROOT warning
# ACTION:
#   shows a root warning if the script was not executed as root.
#

if [[ $(id -u) -ne 0 ]] ; then printf '\U1F64F Please run as root \n' ; exit 1 ; fi

autorise
changemdp
demandeTaperCommande

if [ $reponse = "y" ]
then
      notAutorise
else
      demandeTaperCommande
fi
