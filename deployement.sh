#!/bin/bash
# ETAPE 1: MISE A JOUR DIU SYSTEME
      echo ""
      echo "Mise à jour de la liste des paquets"
           apt update
           apt upgrade -y
           apt install sudo -y
           apt install vim -y

# ETAPE 2: VERIFICATION ET INSTALLATION DES PAQUETS
      echo ""
      echo "
            Vérification de la présence des paquets APT
                => ATOP
                => CURL
                => HTOP
                => NET-TOOLS
                => TMUX
           "
  # Liste des paquets à installer
           paquets=("curl" "tmux" "net-tools" "htop" "atop")

  # Boucle sur les paquets à installer
           for i in "${paquets[@]}"
              do
           # Test de la présence du paquet sur le système et installation de celui-ci si ce n'est pas le cas
              dpkg=$(dpkg -l | grep -w $i | head -n 1 | cut -c-2)

             if [ -z $dpkg ] || [ $dpkg != "ii" ]
             then
                   echo -e "\033[0;31m $i n'est pas installé, installation ! \033[0m"
                   DEBIAN_FRONTEND=noninteractive apt install -y $i
                   echo ""
                   echo " l'installation du paquet $i réussi"
                   echo ""
             else
                   echo -e "\033[0;32m $i est installé ! \033[0m"
             fi
     done

# ETAPE 3: DEPLOYEMENT DE L'ENVIRONNEMENT GIT
    # Installation de GIT
      echo ""
      echo "ETAPE 3: DEPLOYEMENT DE L'ENVIRONNEMENT GIT"
      echo ""
      echo " Mise à jour du système"
           apt update
      echo ""
      echo "L'installation de GIT"
            apt install git -y
      echo ""
      echo "Configuration globale de GIT"
           git config --global user.name "$1"
           git config --global user.email "$2"
      echo ""
      echo "L'environnement GIT est configure avec les informations suivantes:"
           git config --global --list
      echo ""
      echo "Clone du dépôt GIT"
           
# ETAPE 4: DEPOYEMENT DE L'ENVIRONNEMENT DOCKER
      echo " ETAPE 4: DEPLOYEMENT DE L'ENVIRONNEMENT DOCKER"
      echo ""
      echo "Suppression des vieux fichiers docker"
      echo ""
            apt-get remove docker docker-engine docker.io containerd runc -y
      echo ""
      echo "Ajout de la clé GPG officielle de Docker"
      echo ""
            apt-get install ca-certificates curl gnupg lsb-release -y
      echo ""
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
      echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      echo ""
      echo "Mise à jour du système"
      echo ""
            apt-get update
            apt-get upgrade -y
      echo ""
      echo "Installation de docker"
      echo ""
           apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
      echo ""
      echo "Deployement de l'envirennement docker réussit"

# ETAPE 5: DEPLOYEMENT DE DOCKER COMPOSE
      echo ""
      echo "DEPLOYEMENT DE DOCKER COMPOSE"
      echo ""
      echo "installation de docker compose"
      echo ""
      echo ""
           sudo curl -L https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
           sudo chmod +x /usr/local/bin/docker-compose
      echo ""
      echo "Vérification de la presence  du fichier compose"
      echo ""
           docker-compose --version
      echo ""
      echo "Deployement de docker compose réussut"
      echo ""
      echo "Deployement de votre micro datacenter réussit"
           git clone https://github.com/kanimbahub/esgites.git
           cp deployement.sh esgites
           cd esgites
           git add .
           git commit -m"test commit"
           git push

