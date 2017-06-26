#!/bin/bash
source mukoyama.conf
source $MOTION_HOME/lib/common.sh

function spawn_inner {
  cmd=$1
  pid_file=$2
  echo "spawn $cmd"
  if [ -f $pid_file ]; then
    rm $pid_file
  fi
  nohup $cmd > $STD_LOG_FILE 2> $ERR_LOG_FILE &
  echo $! > $pid_file
  cat $pid_file
}

function spawn {
  cmd=$1
  pid_file=$2

  #二重起動防止
  if [ -f $pid_file ]; then
    prev_pid=`cat $pid_file`
    if [ -z "$prev_pid" ]; then
      echo "OK:pid empty $prev_pid"
      spawn_inner "$cmd" $pid_file
      return
    else
      pid_exists=`ps ho pid p $prev_pid`
      if [ -z $pid_exists ]; then
        echo "OK:no pid $prev_pid"
        spawn_inner "$cmd" $pid_file
        return
      fi
    fi
  else
    echo "OK:no pid file"
    spawn_inner "$cmd" $pid_file
    return
  fi
}


mkdir -p $MOTION_HOME/motion/work
mkdir -p $PID_DIR
$MOTION_HOME/lib/mk_motionconf.rb > $MOTION_HOME/motion/work/motion.conf

spawn "motion -c motion/work/motion.conf" $PID_MOTION
if [ -n "$REMOTE_STREAMING_HOST" ]; then
  spawn "ssh -o ServerAliveInterval=60 -N $REMOTE_STREAMING_HOST -R $REMOTE_STREAMING_PORT:localhost:8081" $PID_STREAM
fi
