#!/bin/bash
# This script will only work for Ubuntu TrustyTar
# TODO: configure puppetmaster bootstrap to be distro agnostic

# puppet server defaults 2G Java memory allocation
# for dev/test, this can be drastically lowered.
puppetrepo="puppetlabs-release-pc1-trusty.deb"
osfamily=$1

echo "Pulling repo..."
wget https://apt.puppetlabs.com/${puppetrepo}

echo "Installing repo..."
sudo dpkg -i ${puppetrepo}

case $osfamily in
"Debian")
  sudo apt-get update
  sudo apt-get -y install puppet-agent ;;
"RedHat")
  sudo yum -y update
  sudo yum -y install puppet-agent ;;
*)
  echo "osfamily unrecognized: $osfamily";;
esac

# Add puppet to sudoers path
sudo sed -i 's/:\/bin"/:\/bin:\/opt\/puppetlabs\/bin"/g' /etc/sudoers

# Start the puppet agent
sudo puppet resource service puppet ensure=running enable=true

# Add master to host file
echo "192.168.200.100     puppet" >> /etc/hosts

# Generate certificate with first puppet run
sudo puppet agent -t

# Puppet run cron
sudo puppet apply -e 'cron { "puppet run": command => "puppet agent -t", user => "root", minute => "*/5"}'
