#!/usr/bin/env bash

export SPARK_MASTER_PORT=7077
export SPARK_MASTER_WEBUI_PORT=7080
export SPARK_WORKER_WEBUI_PORT=7081

# The hostname or IP address Cassandra rpc/native protocol is bound to:
# SPARK_CASSANDRA_CONNECTION_HOST="127.0.0.1"

if [ $SPARK_CASSANDRA_CONNECTION_HOST ]; then
    SPARK_CASSANDRA_CONNECTION_HOST_PARAM="-Dspark.cassandra.connection.host=$SPARK_CASSANDRA_CONNECTION_HOST"
else
    SPARK_CASSANDRA_CONNECTION_HOST_PARAM="-Dspark.cassandra.connection.host=$CASSANDRA_ADDRESS"  # defined in dse.in.sh
fi

# The hostname or IP address for the driver to listen on. If there is more network interfaces you
# can specify which one is to be used by Spark Shell or other Spark applications.
# export SPARK_DRIVER_HOST="127.0.0.1"

if [ $SPARK_DRIVER_HOST ]; then
    SPARK_DRIVER_HOST_PARAM="-Dspark.driver.host=$SPARK_DRIVER_HOST"
else
    SPARK_DRIVER_HOST_PARAM=""
fi

# The default amount of memory used by a single executor (also, for the executor used by Spark REPL).
# It can be modified in particular application by command line parameters. 512M is the default value.
# export SPARK_EXECUTOR_MEMORY="512M"

# The default number of cores assigned to each application. It can be modified in particular application. If left blank,
# each Spark application will consume all available cores in the cluster.
# export DEFAULT_PER_APP_CORES="1"

if [ $DEFAULT_PER_APP_CORES ]; then
    DEFAULT_PER_APP_CORES_PARAM="-Dspark.deploy.defaultCores=$DEFAULT_PER_APP_CORES"
else
    DEFAULT_PER_APP_CORES_PARAM=""
fi

# Set the amount of memory used by Spark Worker - if uncommented, it overrides the setting initial_spark_worker_resources in dse.yaml.
# export SPARK_WORKER_MEMORY=2048m

# Set the number of cores used by Spark Worker - if uncommented, it overrides the setting initial_spark_worker_resources in dse.yaml.
# export SPARK_WORKER_CORES=4

# The amount of memory used by SparkShell in the client environment.
export SPARK_REPL_MEM="256M"

# The amount of memory used by Spark Driver program 
export SPARK_DRIVER_MEMORY="512M"

# Directory for Spark temporary files. It will be used by Spark Master, Spark Worker, Spark Shell and Spark applications.
export SPARK_TMP_DIR="/tmp/spark"

# Directory where RDDs will be cached
export SPARK_RDD_DIR="/var/lib/spark/rdd"

# The directory for storing master.log and worker.log files
export SPARK_LOG_DIR="/var/log/spark"

# These options are common to all Spark related daemons and applications
export SPARK_COMMON_OPTS="$SPARK_COMMON_OPTS $SPARK_CASSANDRA_CONNECTION_HOST_PARAM -Dspark.kryoserializer.buffer.mb=10 "

# Individual Java opts for different Spark components
#
# Warning: Be careful when changing temporary subdirectories. Make sure they different for different Spark components
# and they are set with spark.local.dir for Spark Master and Spark Worker, and with java.io.tmpdir for Spark executor,
# Spark shell(repl) and Spark applications. Jobs may not finish properly (hang) if temporary directories overlap.
#
# Warning: When changing temporary or logs locations, consider permissions and ownership of files created by particular
# Spark components. Wrongly specified directories here may result in security related errors.
export SPARK_MASTER_OPTS=" $DEFAULT_PER_APP_CORES_PARAM -Dspark.local.dir=$SPARK_TMP_DIR/master -Dlog4j.configuration=file://$SPARK_CONF_DIR/log4j-server.properties -Dspark.log.file=$SPARK_LOG_DIR/master.log "
export SPARK_WORKER_OPTS=" -Dspark.local.dir=$SPARK_TMP_DIR/worker -Dlog4j.configuration=file://$SPARK_CONF_DIR/log4j-server.properties -Dspark.log.file=$SPARK_LOG_DIR/worker.log "
export SPARK_EXECUTOR_OPTS=" -Djava.io.tmpdir=$SPARK_RDD_DIR -Dlog4j.configuration=file://$SPARK_CONF_DIR/log4j-executor.properties "
export SPARK_REPL_OPTS=" -Djava.io.tmpdir=$SPARK_TMP_DIR/$USER $SPARK_DRIVER_HOST_PARAM "
export SPARK_SUBMIT_OPTS=" -Djava.io.tmpdir=$SPARK_TMP_DIR/$USER $SPARK_DRIVER_HOST_PARAM "

# Directory to run applications in, which will include both logs and scratch space (default: /var/lib/spark/work).
export SPARK_WORKER_DIR="/var/lib/spark/work"

# Temporary storage location (as of Spark 1.0)
export SPARK_LOCAL_DIRS="$SPARK_RDD_DIR"