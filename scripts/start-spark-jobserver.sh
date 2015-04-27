#!/usr/bin/env bash
ansible-playbook \
-i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
--private-key=.vagrant/machines/dsenode02/virtualbox/private_key \
-u vagrant \
playbook.yml \
--tags "start-spark-jobserver"
