#!/bin/bash
# This script will only work for Ubuntu TrustyTar
# TODO: configure puppetmaster bootstrap to be distro agnostic

# puppet server defaults 2G Java memory allocation
# for dev/test, this can be drastically lowered.
pJavaMem="512m"

echo "Pulling repo..."
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb

echo "Installing repo..."
sudo dpkg -i puppetlabs-release-pc1-trusty.deb

echo "Updating apt..."
sudo apt-get update

echo "Pulling puppetserver..."
sudo apt-get -y install puppet-agent

# Start the puppet agent
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

# Add master to host file
echo "192.168.200.100     puppet" >> /etc/hosts

# Generate certificate with first puppet run
sudo /opt/puppetlabs/bin/puppet agent -t
