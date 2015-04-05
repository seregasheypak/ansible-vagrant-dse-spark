# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.define "dsenode01" do |node1|
    node1.vm.box = "precise64"
    node1.vm.hostname = "dsenode01"
    node1.vm.network  "private_network", ip: "192.168.56.10"
  end

  config.vm.define "dsenode02" do |node2|
    node2.vm.box = "precise64"
    node2.vm.hostname = "dsenode02"
    node2.vm.network  "private_network", ip: "192.168.56.20"
  end

  config.vm.define "dsenode03" do |node3|
    node3.vm.box = "precise64"
    node3.vm.hostname = "dsenode03"
    node3.vm.network  "private_network", ip: "192.168.56.30"
  end

  config.vm.define "dsenode04" do |node4|
    node4.vm.box = "precise64"
    node4.vm.hostname = "dsenode04"
    node4.vm.network  "private_network", ip: "192.168.56.40"
  end

   config.vm.provision "ansible" do |ansible|
    ansible.playbook = "deploy.yml"
    ansible.groups = {
        "dse" => ["dsenode01","dsenode02","dsenode03"],
        "opscenter" => ["dsenode04"],
        "sparkmasters" => ["dsenode01"],
        "sparkworkers" => ["dsenode01","dsenode02","dsenode03"]
    }
  end

 config.vm.provider "virtualbox" do |vb|
   vb.customize ["modifyvm", :id, "--memory", "2048"]
 end

end
