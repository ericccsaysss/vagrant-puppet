# -*- mode: ruby -*-
# vi: set ft=ruby :
# TODO: pass agent hosts to puppetmaster autosign.configure


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.define "puppet" do |p|
      p.vm.box = "ubuntu/trusty64"
      p.vm.hostname = "puppet"
      p.vm.network "private_network", ip: "192.168.200.100"
      p.vm.provision "shell", path: "./bootstrap/MasterBootstrap.sh"
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
    end


    config.vm.define "agent", autostart: false do |a|
      a.vm.box = "ubuntu/trusty64"
      a.vm.hostname = "agent"
      a.vm.network "private_network", ip: "192.168.200.110"
      a.vm.provision "shell", path: "./bootstrap/AgentBootstrap.sh"
    end

end
