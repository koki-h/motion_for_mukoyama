#!/bin/bash
source mukoyama.conf
mkdir -p $MOTION_HOME/motion/work
$MOTION_HOME/lib/mk_motionconf.rb > $MOTION_HOME/motion/work/motion.conf
nohup motion -c motion/work/motion.conf > $STD_LOG_FILE 2> $ERR_LOG_FILE &
