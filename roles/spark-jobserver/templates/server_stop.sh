#!/bin/bash
# Script to stop the job server

echo "lol1"
PIDFILE="/var/run/spark-jobserver.pid"

cat "$PIDFILE"

echo "lol2"
if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
   echo 'Job server not running'
else
  echo 'Stopping job server...'
  kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
  echo '...job server stopped'
fi