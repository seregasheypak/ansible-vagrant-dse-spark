#!/usr/bin/env bash
#
# Start daemon script for spark JOBSERVER
#
# Author: Josef Lindman Hörnlund (josef@appdata.biz)

. /lib/lsb/init-functions

# Env variables
NAME="spark-jobserver"
SPARK_JOBSERVER_BIN="{{ jobserver.location }}/server_start.sh"
SPARK_JOBSERVER_BIN_STOP="{{ jobserver.location }}/server_stop.sh"
SPARK_JOBSERVER_LOG="{{ jobserver.log }}/jobserver.log"
SPARK_JOBSERVER_OPTIONS=" "
PIDFILE="/var/run/${NAME}.pid"

find_jobserver_process() {
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
  pid="`${SPARK_JOBSERVER_BIN} ${SPARK_JOBSERVER_OPTIONS} > ${SPARK_JOBSERVER_LOG} 2>&1 & echo $!`"
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
    $("${SPARK_JOBSERVER_BIN_STOP}")
    log_success_msg "${NAME}"
  fi
}

restart() {
  stop
  start
}

case "${1}" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    find_jobserver_process
    ;;
  restart)
    restart
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
esac

exit 0
