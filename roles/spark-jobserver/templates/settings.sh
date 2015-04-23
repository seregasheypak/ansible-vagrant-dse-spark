#!/usr/bin/env bash
# Environment and deploy file
# For use with bin/server_deploy, bin/server_package etc.
#DEPLOY_HOSTS="hostname1.net
#              hostname2.net"

APP_USER=spark
APP_GROUP=spark

INSTALL_DIR={{jobserver.location}}
LOG_DIR=/var/log/jobserver
PIDFILE=/var/run/spark-jobserver.pid
SPARK_HOME={{spark.location}}
SPARK_CONF_DIR=$SPARK_HOME/conf
