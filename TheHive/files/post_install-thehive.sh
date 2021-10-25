#!/bin/bash

# OSQuery
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
sudo add-apt-repository "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/deb deb main"
sudo apt -qq update
sudo apt -qq --allow-unauthenticated install osquery
# General update
sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"  upgrade
# Dependancies
sudo apt -yqq install nginx language-pack-en
# The Hive Installation
sudo echo 'deb https://dl.bintray.com/cert-bdf/debian any main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list
sudo apt-key adv --keyserver hkp://pgp.mit.edu --recv-key 562CBC1C
sudo apt -qq update
sudo apt -yqq --allow-unauthenticated install thehive
# ElasticSearch
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key D88E42B4
sudo echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt update
sudo apt -yqq install elasticsearch
sudo systemctl enable elasticsearch.service
# Misc
sudo mkdir /home/ubuntu/.ssh
sudo chmod 700 /home/ubuntu/.ssh
sudo chown -R ubuntu.ubuntu /home/ubuntu/.ssh
# Ensure we are enabled
sudo systemctl enable thehive.service
