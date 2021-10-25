#!/bin/bash

# OSQuery
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
sudo add-apt-repository "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/deb deb main"
sudo apt -qq update
sudo apt -qq --allow-unauthenticated install osquery
# General update
sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"  upgrade
# The Hive Installation
sudo echo 'deb https://dl.bintray.com/cert-bdf/debian any main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list
sudo apt-key adv --keyserver hkp://pgp.mit.edu --recv-key 562CBC1C
sudo apt -qq update
sudo apt -yqq --allow-unauthenticated install cortex git language-pack-en python-pip
sudo pip2 install --upgrade pip

# Cortex Analyzers
sudo git clone https://github.com/TheHive-Project/Cortex-Analyzers.git /opt/Cortex-Analyzers
sudo git clone https://github.com/Yara-Rules/rules.git /opt/Yara-Rules
sudo git clone https://github.com/firehol/blocklist-ipsets /opt/FireHOLBlocklists/blocklists
sudo git clone https://github.com/MISP/misp-warninglists /opt/misp-warninglists


# Misc
# Ensure we are enabled
sudo systemctl enable cortex.service
