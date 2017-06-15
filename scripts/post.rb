#!/usr/bin/env ruby
def send_picture
  ts = timestamp($filename)
  u = "#{$url}/pictures/upload?id=#{$id}&token=#{$token}&time_stamp=#{ts}&motion_sensor=#{$motion_sensor.to_s}"
  cmd = "curl -s -S -X POST -F file=@'#{$filename}' '#{u}'"
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
send_picture
