# -*- mode: ruby -*-
# vi: set ft=ruby :
# TODO: pass agent hosts to puppetmaster autosign.configure
# TODO: auto generate hostname,ip when doing multiple agents
require 'yaml'

VAGRANTFILE_API_VERSION = "2"
AGENTS = YAML.load_file('agents.yml')


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.define "puppet", autostart: true do |p|
      p.vm.box = "ubuntu/trusty64"
      p.vm.hostname = "puppet.pdev.local"
      p.vm.network "private_network", ip: "192.168.200.100"
      p.vm.provision "shell", path: "./bootstrap/MasterBootstrap.sh"
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
    end

  AGENTS.each do |agent|
    config.vm.define agent['name'], autostart: true do |a|
      a.vm.box = agent['box']
      a.vm.hostname = agent['name']
      a.vm.network "private_network", ip: agent['ip']
      a.vm.provision "shell", path: "./bootstrap/AgentBootstrap.sh", args: "agent['osfamily']"
    end
  end

end
