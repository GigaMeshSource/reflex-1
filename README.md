Le docker-compose deploie le systeme de Reflex d'*HANNOVER* sur un server Tomcat

### Install docker on EC2
* Link : https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html
# 1    : Mettez à jour les packages installés et le cache du package sur votre instance.
    sudo yum update -y
# 2    : Installez le package de moteur Docker le plus récent. 
    ** Amazon Linux 2
        sudo amazon-linux-extras install docker
    ** Amazon Linux
        sudo yum install docker
# 3    : Lancez le service Docker.
    sudo service docker start

# 4    : Ajoutez ec2-user au groupe docker afin de pouvoir exécuter les commandes Docker sans utiliser sudo.
    sudo usermod -a -G docker ec2-user
# 5    : Verifire que docker est bien installé
    sudo docker ps 

### En cas de problème avec docker-compose
* Link: https://stackoverflow.com/questions/36685980/docker-is-installed-but-docker-compose-is-not-why

    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose

    sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose

    sudo chmod +x /usr/bin/docker-compose

### Modification du mot de passe de connexion à RAS
Pour modifier le mot, priere de se referer au fichier: reflex->Reflex->reflex-config->ras-web->users.properties

La valeur de *com.hannoverre.reflex.ras.password* doit être chiffrée en suivant les instructions decrites dans */ras/configuration/security.html* de la documentation d'*HANNOVER* (en utilisant le logiciel htpasswd comme suit)
    *$ htpasswd -n -b -B username password*

Par defaut le mot de passe est : password et le username: user

### Le deploiement du Docker
    docker-compose up -d reflex










