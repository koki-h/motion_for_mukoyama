#!/usr/bin/env ruby
def send_picture
  ts = Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")
  u = "#{$url}/pictures/upload?id=#{$id}&token=#{$token}&time_stamp=#{ts}&motion_sensor=#{$motion_sensor.to_s}"
  cmd = "curl -s -S -X POST -F file=@'#{$filename}' '#{u}'"
  system(cmd)
  puts
end

$filename = ARGV[0] # saved file name
$url      = ENV['MUKOYAMA_URL']
$id       = ENV['MUKOYAMA_ID']
$token    = ENV['MUKOYAMA_TOKEN']
send_picture
