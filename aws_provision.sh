#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID='AKIAIZIGOEOI32P2HE4A'
export AWS_SECRET_ACCESS_KEY='efAIJcxQC1eSKdNE+tMFFthI6a7yxaqooHBsvym'
ansible-playbook --private-key=serega_test -u ubuntu -i hosts.aws  playbook.yml
#-vvvv
#--tags spark-jobserver



#OPS CENTER S3 backup

#created new user for opscenter
# opscentercassandrabackup
#Access Key ID:
#AKIAIWDMYQFCNQKSMDBA
#Secret Access Key:
#XYBChIeJHhQqNdFmUyr+MZ9xSL0OhB24C9Wm9RiZ



#seregabackupcassandra
#serega_aws_test
#Access Key ID:
#AKIAJ6OZSYOUSRC6TWSA
#Secret Access Key:
#BQ/nvbZXET71tpbr0GCFNYGXOAMPWYm0LpCtNK5J