#!/bin/bash
source mukoyama.conf
./lib/mk_motionconf.rb > motion/work/motion.conf
nohup motion -c motion/work/motion.conf &
