#!/bin/bash
# Starts a Spark jobserver
#
# chkconfig: 2345 87 13
# description: Spark jobserver
#
### BEGIN INIT INFO
# Provides:          spark-worker
# Short-Description: Spark worker
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Required-Start:    $syslog $remote_fs
# Required-Stop:     $syslog $remote_fs
# Should-Start:
# Should-Stop:
### END INIT INFO

. /lib/lsb/init-functions
BIGTOP_DEFAULTS_DIR=${BIGTOP_DEFAULTS_DIR-/etc/default}
[ -n "${BIGTOP_DEFAULTS_DIR}" -a -r ${BIGTOP_DEFAULTS_DIR}/hadoop ] && . ${BIGTOP_DEFAULTS_DIR}/hadoop
[ -n "${BIGTOP_DEFAULTS_DIR}" -a -r ${BIGTOP_DEFAULTS_DIR}/spark-worker ] && . ${BIGTOP_DEFAULTS_DIR}/spark-worker

# Autodetect JAVA_HOME if not defined
. /usr/lib/bigtop-utils/bigtop-detect-javahome

RETVAL_SUCCESS=0

STATUS_RUNNING=0
STATUS_DEAD=1
STATUS_DEAD_AND_LOCK=2
STATUS_NOT_RUNNING=3
STATUS_OTHER_ERROR=102


ERROR_PROGRAM_NOT_INSTALLED=5
ERROR_PROGRAM_NOT_CONFIGURED=6


RETVAL=0
SLEEP_TIME=5
PROC_NAME="java"

DAEMON="spark-worker"
DESC="Spark worker"
EXEC_PATH="/usr/lib/spark/bin/spark-class"
EXEC_DIR=""
SVC_USER="spark"
DAEMON_FLAGS=""
CONF_DIR="/etc/spark/conf"
PIDFILE="/var/run/spark/spark-worker.pid"
LOCKDIR="/var/lock/subsys"
LOCKFILE="$LOCKDIR/spark-worker"
WORKING_DIR="/var/lib/spark"

install -d -m 0755 -o spark -g spark /var/run/spark 1>/dev/null 2>&1 || :
[ -d "$LOCKDIR" ] || install -d -m 0755 $LOCKDIR 1>/dev/null 2>&1 || :
start() {
    [ -x $EXE_FILE ] || exit $ERROR_PROGRAM_NOT_INSTALLED
    log_success_msg "Starting $DESC (${DAEMON}): "

    checkstatusofproc
    status=$?
    if [ "$status" -eq "$STATUS_RUNNING" ]; then
        log_success_msg "${DESC} is running"
        exit 0
    fi

    LOG_FILE=/var/log/spark/${DAEMON}.out

    if [ -f $CONF_DIR/spark-env.sh ]; then
        . $CONF_DIR/spark-env.sh
    fi

    su -s /bin/bash $SVC_USER -c "nohup nice -n 0 \
        ${EXEC_PATH} org.apache.spark.deploy.worker.Worker spark://$STANDALONE_SPARK_MASTER_HOST:$SPARK_MASTER_PORT $DAEMON_FLAGS \
        > $LOG_FILE 2>&1 & "'echo $!' > "$PIDFILE"

    sleep 3

    checkstatusofproc
    RETVAL=$?
    [ $RETVAL -eq $STATUS_RUNNING ] && touch $LOCKFILE
    return $RETVAL
}
stop() {
    log_success_msg "Stopping $DESC (${DAEMON}): "
    killproc -p $PIDFILE java
    RETVAL=$?

    [ $RETVAL -eq $RETVAL_SUCCESS ] && rm -f $LOCKFILE $PIDFILE
    return $RETVAL
}
restart() {
  stop
  start
}

checkstatusofproc(){
  pidofproc -p $PIDFILE $PROC_NAME > /dev/null
}

checkstatus(){
  checkstatusofproc
  status=$?

  case "$status" in
    $STATUS_RUNNING)
      log_success_msg "${DESC} is running"
      ;;
    $STATUS_DEAD)
      log_failure_msg "${DESC} is dead and pid file exists"
      ;;
    $STATUS_DEAD_AND_LOCK)
      log_failure_msg "${DESC} is dead and lock file exists"
      ;;
    $STATUS_NOT_RUNNING)
      log_failure_msg "${DESC} is not running"
      ;;
    *)
      log_failure_msg "${DESC} status is unknown"
      ;;
  esac
  return $status
}

condrestart(){
  [ -e $LOCKFILE ] && restart || :
}

check_for_root() {
  if [ $(id -ur) -ne 0 ]; then
    echo 'Error: root user required'
    echo
    exit 1
  fi
}

service() {
  case "$1" in
    start)
      check_for_root
      start
      ;;
    stop)
      check_for_root
      stop
      ;;
    status)
      checkstatus
      RETVAL=$?
      ;;
    restart)
      check_for_root
      restart
      ;;
    condrestart|try-restart)
      check_for_root
      condrestart
      ;;
    *)
      echo $"Usage: $0 {start|stop|status|restart|try-restart|condrestart}"
      exit 1
  esac
}

service "$@"

exit $RETVAL