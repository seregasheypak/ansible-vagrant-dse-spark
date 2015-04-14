#!/usr/bin/env bash
#
# Start daemon script for spark MASTER
#
# Author: Anthony Corbacho <corbacho.anthony@gmail.com>

. /lib/lsb/init-functions

# Env variables
NAME="spark-master"
SPARK_MASTER_BIN="{{ spark.location }}/sbin/start-master.sh"
SPARK_MASTER_BIN_STOP="{{ spark.location }}/sbin/stop-master.sh"
SPARK_MASTER_OPTIONS=" "
PIDFILE="/var/run/${NAME}.pid"

find_spark_process() {
  local pid

  if [[ -f "${PIDFILE}" ]]; then
    pid="`cat ${PIDFILE}`"
    if [[ -z "`ps axf | grep ${pid} | grep -v grep`" ]]; then
      log_failure_msg "${NAME} running but proccess is dead"
    else
      log_success_msg "${NAME} is running"
    fi
  else
    log_failure_msg "${NAME} is not running"
  fi
}

start() {
  local pid
  if [[ -f "${PIDFILE}" ]]; then
    log_failure_msg "${NAME} is running"
  fi
  pid="`${SPARK_MASTER_BIN} ${SPARK_MASTER_OPTIONS} > /dev/null 2>&1 & echo $!`"
  if [[ -z "${pid}" ]]; then
    log_failure_msg "${NAME}"
  else
    log_success_msg "${NAME}"
    echo ${pid} > ${PIDFILE}
  fi
}

stop() {
  local pid

  if [[ ! -f "${PIDFILE}" ]]; then
    log_failure_msg "${NAME} is not running"
  fi
  pid="`cat ${PIDFILE}`"
  if [[ -z "${pid}" ]]; then
    log_failure_msg "${NAME} is not running"
  else
    kill -9 ${pid}
    rm -f ${PIDFILE}
    $("${SPARK_MASTER_BIN_STOP}")
    log_success_msg "${NAME}"
  fi
}

case "${1}" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    find_spark_process
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
esac

exit 0