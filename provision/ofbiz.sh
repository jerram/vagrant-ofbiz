#!/usr/bin/env bash
cd /vagrant
source .env || exit 1
sudo hostname ${HOSTNAME}
echo "${HOSTNAME}"  | sudo tee /etc/hostname
sudo usermod -a -G www-data `whoami`
# newgrp www-data
sudo debconf-set-selections <<< "debconf shared/accepted-oracle-license-v1-1 select true"
sudo debconf-set-selections <<< "debconf shared/accepted-oracle-license-v1-1 seen true"
export DEBIAN_FRONTEND=noninteractive
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt update -y
sudo apt upgrade -y
sudo apt -qq install -y \
  python-software-properties \
  oracle-java8-installer \
  wget \
  unzip
# apt-get install -y --no-install-recommends default-jdk
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc
source ~/.bashrc
# Start Ofbiz
wget http://mirror.dsrg.utoronto.ca/apache/ofbiz/apache-ofbiz-16.11.04.zip
unzip apache-ofbiz-16.11.04.zip
cd apache-ofbiz-16.11.04
time ./gradlew cleanAll loadDefault
time ./gradlew ofbiz
echo "open https://${HOSTNAME}:8443/ordermgr/control/main"
