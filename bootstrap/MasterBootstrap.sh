#!/bin/bash
# This script will only work for Ubuntu TrustyTar
# TODO: configure puppetmaster bootstrap to be distro agnostic

# puppet server defaults 2G Java memory allocation
# for dev/test, this can be lowered.
pJavaMem="1g"

echo "Pulling repo..."
cd ~ && wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb

echo "Installing repo..."
sudo dpkg -i puppetlabs-release-pc1-trusty.deb

echo "Updating apt..."
sudo apt-get update

echo "Pulling puppetserver..."
sudo apt-get -y install puppetserver

# Add puppet to sudoers path
sudo sed -i 's/:\/bin"/:\/bin:\/\/opt\/puppetlabs\/bin"/g' /etc/sudoers

sed -i "s/2g/${pJavaMem}/g" /etc/default/puppetserver

# Open port to allow for agents to talk to server
sudo iptables -A INPUT -p tcp --dport 8140 -j ACCEPT

sudo puppet resource service puppetserver ensure=running enable=true
sudo puppet apply -e 'file { "/etc/puppetlabs/puppet/autosign.conf": ensure => "present",content => "*.pdev.local\n", mode => "0644"}'
sudo puppet agent -t
