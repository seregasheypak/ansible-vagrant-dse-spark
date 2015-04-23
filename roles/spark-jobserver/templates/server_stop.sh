#!/bin/bash
# Script to stop the job server

PIDFILE="/var/run/spark-jobserver.pid"

echo "got pid frmo file: " ${PIDFILE} " pid value:" $(cat "$PIDFILE")

echo "server_stop:02"
if [ ! -f "$PIDFILE" ] || ! kill -9 $(cat "$PIDFILE"); then
   echo 'Job server not running'
else
  echo 'Stopping job server...'
  kill -9 $(cat "$PIDFILE") && rm -f "$PIDFILE"
  echo '...job server stopped'
fi