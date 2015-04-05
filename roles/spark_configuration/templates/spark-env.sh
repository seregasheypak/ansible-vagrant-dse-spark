#!/usr/bin/env bash                                                                                                                                                            

export DEFAULT_HADOOP_HOME=/usr/lib/hadoop

export SPARK_DAEMON_JAVA_OPTS=""

export SPARK_MASTER_WEBUI_PORT={{ spark.webui }}

export SPARK_WORKER_MEMORY={{ spark.workermemory }}
export SPARK_DRIVER_MEMORY={{ spark.drivermemory }}
export SPARK_DAEMON_MEMORY={{ spark.daemonmemory }}
