#!/bin/sh

sudo apt install libappindicator-dev openjdk-11-jre -y
curl -fsSl https://downloads.ortussolutions.com/debs/gpg | sudo apt-key add -
echo "deb https://downloads.ortussolutions.com/debs/noarch /" | sudo tee -a /etc/apt/sources.list.d/commandbox.list
sudo apt update -y -qq
sudo apt install apt-transport-https commandbox -y
