#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

#Setup Generale
echo "Installing openjdk 18, screen, net-tools, maven, pip"
apt install openjdk-18-jre-headless screen net-tools maven python3-pip -y
VARIP=$(hostname -I | awk '{print $1}')
mkdir ./setup

#Setup Docker
echo "Installing docker-ce"
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable" -y
apt install docker-ce -y

#Setup Minecraft 1.18
echo "Setting up Minecraft Server 1.18"
mkdir ./setup/minecraft-server
cd ./setup/minecraft-server
wget https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar
touch eula.txt
echo "eula=true" >> eula.txt
chmod +x server.jar
screen -AmdS mserver java -Xmx1024M -Xms1024M -jar server.jar nogui
cd ..

#Setup Apache Solr 8.11.0
echo "Setting up Apache Solr 8.11.0"
wget https://archive.apache.org/dist/lucene/solr/8.11.0/solr-8.11.0.tgz
tar xzf solr-8.11.0.tgz
bash solr-8.11.0/bin/install_solr_service.sh solr-8.11.0.tgz

#Setup Webapp POC
echo "Setting up vulnerable POC Webapp"
git clone https://github.com/kozmer/log4j-shell-poc.git
cd ./log4j-shell-poc/
docker build -t log4j-shell-poc .
screen -AmdS dockerpoc docker run --network host log4j-shell-poc
cd ..

#Setup Autostart
touch autostart.sh
echo "#!/bin/bash" >> autostart.sh
echo "cd $(pwd)/minecraft-server" >> autostart.sh
echo "screen -AmdS mserver java -Xmx1024M -Xms1024M -jar server.jar nogui" >> autostart.sh
echo "screen -AmdS dockerpoc docker run --network host log4j-shell-poc" >> autostart.sh
chmod +x autostart.sh

#Setup Vulnerable log4j - Java Unsafe deserialization app
#JNDI Exploit kit
#ysoserial
git clone https://github.com/vidrez/log4j-deserialization-rce-POC.git
git clone https://github.com/pimps/ysoserial-modified.git
git clone https://github.com/pimps/JNDI-Exploit-Kit.git
git clone https://github.com/vidrez/log4j-rce-poc

sudo update-alternatives --auto java
cd ./log4j-deserialization-rce-POC/
sudo mvn package

echo " "
echo "--- Setup ended ---"
echo "Minecraft Server 1.18 available at: ${VARIP}"
echo "Web UI Apache Solr v8.11.0 available at: ${VARIP}:8983"
echo "Web app Proof Of Concept available at: ${VARIP}:8080"
