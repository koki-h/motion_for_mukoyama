#!/bin/bash
source mukoyama.conf
source $MOTION_HOME/lib/common.sh

function read_pid {
  pid_file=$1
  if [ -f $pid_file ]; then
    echo `cat $pid_file`
  fi
}

function check_pid {
  echo `ps ho pid p $pid_m $pid_s`
}

pid_m=`read_pid $PID_MOTION`
pid_s=`read_pid $PID_STREAM`
kill $pid_m $pid_s

#プロセス終了を待つ
while [ -n "`check_pid`" ]
do
  sleep 1
done
