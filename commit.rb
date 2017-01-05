#!/usr/bin/ruby

#--------------------------
# commit.rb
# Author: a-yoshino
# Last Update: 2017/1/5
# Usage: ruby commit.rb
#--------------------------

require "open3"
require "net/http"
require "uri"
require "time"
require "json"
require 'base64'
require "yaml"

#----Load config file------
confFileName = "./config.yml"
config = YAML.load_file(confFileName)

# デバイスID (Cumulocityが払い出したID)
DEVICEID = config["deviceId"]
# CumulocityへのログインID
USERID = config["userId"]
# Cumulocityへのログインパスワード
PASSWD = config["password"]
# CumulocityのURL
URL = config["url"] + "/measurement/measurements/"
#----------------------------

# status of magnet sensor(0: contact, 1: noncontact)
status = nil
# status of led(0: off, 1:on)
ledstatus = 0

uri = URI.parse(URL)
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true # HTTPS通信を使用

req = Net::HTTP::Post.new(uri.request_uri)

# Add HTTP request header
req["Authorization"] = "Basic " + Base64.encode64(USERID + ":" + PASSWD).chomp
req["Content-Type"] = "application/vnd.com.nsn.cumulocity.measurement+json; charset=UTF-8; ver=0.9"
req["Accept"] = "application/vnd.com.nsn.cumulocity.measurement+json; charset=UTF-8; ver=0.9"

# Thread for captureing button press event
t1 = Thread.start {
  loop do
    # capture the button status
    ret = `python shell_grove_button.py`
    button = ret.chomp.to_i

    # if led is off and button is pressed, turn on led and ledstatus becomes 1
    if button == 1 && ledstatus == 0 then
      led = `python shell_grove_led.py 1`
      ledstatus = 1
    # if led is on and button is pressed, turn off led and ledstatus becomes 0
    elsif button == 1 && ledstatus == 1 then
      led = `python shell_grove_led.py 0`
      ledstatus = 0
    end

  sleep(0.5)

  end

}

# capture a magnet sensor value and sends it to cloud
loop do
  # capture a magnet sensor value
  ret = `python shell_grove_tilt.py`
  status = ret.chomp.to_i

  p "status: " + ret.chomp

  # if ledstatus is 1, make sounds
  if ledstatus == 1 then
    if status == 1 then
      cmd = "sudo aplay /home/pi/rizap2.wav"
      Open3.popen3("#{cmd} > /dev/null 2>&1")
    elsif status == 0 then
      cmd = "sudo aplay /home/pi/rizap1.wav"
      Open3.popen3("#{cmd} > /dev/null 2>&1")
    end
  end

  # get current time
  time = Time.now.iso8601

  # make data body
  payload = {
  	"MagnetSwitch" => {
  		"Magnet" =>  { 
  			"value" =>  status,
  			"unit" =>  ""
        }
    },
    "time" =>  time, 
    "source" => {
    	"id" => DEVICEID
    }, 
    "type" =>  "MagnetSwitch"

  }.to_json
 
  # send data
  req.body = payload 
  res = https.request(req)

  # confirm response data
  puts "code -> #{res.code} #{res.message}"
  puts "body -> #{res.body}"

  sleep(3.5)

end




 
 

 

