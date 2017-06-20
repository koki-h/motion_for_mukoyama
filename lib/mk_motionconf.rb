#!/usr/bin/env ruby
require 'erb'

motion_home       = ENV['MOTION_HOME']
target_dir        = ENV['MOTION_TARGET_DIR'] || '/var/lib/motion'
threshold         = ENV['MOTION_THRESHOLD'] || 1500
stream_localhost  = ENV['MOTION_STREAM_LOCALHOST'] || 'on'
snapshot_interval = ENV['MOTION_SNAPSHOT_INTERVAL'] || 0
rotate            = ENV['MOTION_ROTATE'] || 0
config_template = "#{motion_home}/motion/template/motion.conf.erb"
erb = ERB.new(open(config_template).read)
puts erb.result(binding)
