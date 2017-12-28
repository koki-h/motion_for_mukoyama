#!/usr/bin/env ruby
require 'fileutils'

def send_picture
  ts = timestamp($filename)
  u = "#{$url}/pictures/upload"
  cmd = "curl -s -S -X POST -F file=@'#{$filename}' -F id='#{$id}' -F token='#{$token}' -F time_stamp='#{ts}' -F motion_sensor='#{$motion_sensor.to_s}' '#{u}'"
  puts cmd
  system(cmd)
  puts
end

def timestamp(filename)
  time = filename.split(/-/)[1]
  year   = time[0..3]
  month  = time[4..5]
  day    = time[6..7]
  hour   = time[8..9]
  minute = time[10..11]
  second = time[12..13]
  Time.local( year, month, day, hour, minute, second).strftime("%Y-%m-%dT%H:%M:%S%z")
end

$filename = ARGV[0] # saved file name
$url      = ENV['MUKOYAMA_URL']
$id       = ENV['MUKOYAMA_ID']
$token    = ENV['MUKOYAMA_TOKEN']
$delete_img = ENV['MUKOYAMA_DELETE_IMG']
send_picture
if $delete_img == 'true'
  FileUtils.rm $filename
end
