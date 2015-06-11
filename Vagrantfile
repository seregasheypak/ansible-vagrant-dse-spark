# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #https://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-i386-juju-vagrant-disk1.box
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/ubuntu/trusty64"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.define "dsenode01" do |node1|
    node1.vm.box = "ubuntu/trusty64"
    node1.vm.hostname = "dsenode01"
    node1.vm.network  "private_network", ip: "192.168.56.10"
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "3072"]
    end
  end

  config.vm.define "dsenode02" do |node2|
    node2.vm.box = "ubuntu/trusty64"
    node2.vm.hostname = "dsenode02"
    node2.vm.network  "private_network", ip: "192.168.56.20"
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "3072"]
    end
  end

  #if we want short installation
  unless ENV['my_playbook'] == 'dse-playbook.yml'

    config.vm.define "dsenode03" do |node3|
      node3.vm.box = "ubuntu/trusty64"
      node3.vm.hostname = "dsenode03"
      node3.vm.network  "private_network", ip: "192.168.56.30"
      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "3072"]
      end
    end

    config.vm.define "dsenode04" do |node4|
      node4.vm.box = "ubuntu/trusty64"
      node4.vm.hostname = "dsenode04"
      node4.vm.network  "private_network", ip: "192.168.56.40"
      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
      end

    end
  end

   config.vm.provision "ansible" do |ansible|
    ansible.playbook = ENV['my_playbook'] #"playbook.yml"
    ansible.groups = {
        "dse" => ["dsenode01","dsenode02","dsenode03"],
        "dse-only" => ["dsenode01","dsenode02"],
        "opscenter" => ["dsenode04"],
        "sparkmasters" => ["dsenode01"],
        "sparkworkers" => ["dsenode01","dsenode02","dsenode03"],
        "sparkjobserver" => ["dsenode02"],
        "sparkhistory" => ["dsenode02"],
        "influxdb" => ["dsenode03"],
        "grafana" => ["dsenode03"],
    }
  end


end
