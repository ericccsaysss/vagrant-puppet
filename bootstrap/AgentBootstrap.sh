#!/bin/bash
# This script will only work for Ubuntu TrustyTar
# TODO: configure puppetmaster bootstrap to be distro agnostic

# puppet server defaults 2G Java memory allocation
# for dev/test, this can be drastically lowered.
puppetrepo="puppetlabs-release-pc1-trusty.deb"

echo "Pulling repo..."
wget https://apt.puppetlabs.com/${puppetrepo}

echo "Installing repo..."
sudo dpkg -i ${puppetrepo}

echo "Updating apt..."
sudo apt-get update

echo "Pulling puppet..."
sudo apt-get -y install puppet-agent

# Add puppet to sudoers path
sudo sed -i 's/:\/bin"/:\/bin:\/opt\/puppetlabs\/bin"/g' /etc/sudoers

# Start the puppet agent
sudo puppet resource service puppet ensure=running enable=true

# Add master to host file
echo "192.168.200.100     puppet" >> /etc/hosts

# Generate certificate with first puppet run
sudo puppet agent -t
