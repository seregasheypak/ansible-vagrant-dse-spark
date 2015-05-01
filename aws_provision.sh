#!/usr/bin/env bash

ansible-playbook --private-key=serega_test -u ubuntu -i hosts.aws  playbook.yml