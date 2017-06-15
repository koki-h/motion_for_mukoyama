#!/usr/bin/env ruby
require 'erb'
motion_home = ENV['MOTION_HOME']
config_template = "#{motion_home}/motion/template/motion.conf.erb"
erb = ERB.new(open(config_template).read)
puts erb.result(binding)
