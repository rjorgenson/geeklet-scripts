#!/usr/bin/env ruby
#coding: utf-8

require 'open-uri'
require 'optparse'
options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: netstats.rb [options]"
  
  options[:iface] = 'en1'
  opts.on( '-i IFACE', '--iface IFACE', 'Set iface to monitor' ) do |iface|
    options[:iface] = iface
  end
  
  options[:wifi] = false
  opts.on( '-w', '--wifi', 'iface is a wireless access point' ) do
    options[:wifi] = true
  end

  options[:server] = 'google.com'
  opts.on( '-s', '--server', 'set the server to gauge ping response[google.com]' ) do |server|
    options[:server] = server
  end

  opts.on( '-h', '--help', 'Displays this help screen' ) do
    puts opts
    exit
  end
end

parser.parse!

class Net_Stats
  AIRPORT_UTILITY = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  
  def initialize(opts)
      @options = opts
  end

  def get_internal_ip
    ifc = %x{ifconfig #{@options[:iface]}}
    if ifc.each_line.grep(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)[0] == nil then
      iip = "none"
    else
      iip = ifc.each_line.grep(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)[0].strip.split(" ")[1]
    end
    return iip
  end
  
  def get_external_ip
    begin
      return %x{curl -s http://icanhazip.com}.strip
    rescue
      return "none"
    end
  end
  
  def get_access_point
    ap = %x{#{Net_Stats::AIRPORT_UTILITY} -I | grep ' SSID' | awk '{ print $2 }'}
    if ap.to_s == "" then
      return "none"
    else
      return ap.to_s.strip
    end
    #ap.to_s == "" ? return "none" : return ap
  end

  def get_response_time
    begin
      return %x{ping -c 1 -t 2 -Q #{@options[:server]}}.each_line.grep(/round-trip/)[0].strip.split(" = ")[1].split("/")[2].to_f.round.to_s + "ms"
    rescue
      return "No Network"
    end
  end
  
  def get_txrx_totals
    rx = %x{netstat -ib | grep -e "#{@options[:iface]}" -m 1 | awk '{print $7}'}.to_i
    tx = %x{netstat -ib | grep -e "#{@options[:iface]}" -m 1 | awk '{print $10}'}.to_i
    return self.human_readable_bytes(tx) + " : " + self.human_readable_bytes(rx)
  end
  
  def human_readable_bytes(bytes)
    level = 0
    until bytes < 1024
      remainder = bytes % 1024
      bytes = bytes / 1024
      level += 1
    end
    remainder = ((remainder.to_f / 1024) * 100).to_i
    output = bytes.to_s + "." + remainder.to_s
    case level
    when 0
      output = output + " B"
    when 1
      output = output + " KB"
    when 2
      output = output + " MB"
    when 3
      output = output + " GB"
    when 4
      output = output + " TB"
    end
  end
end

netstats = Net_Stats.new(options)
    
iface = options[:iface]
ping_server = options[:server]

internal_ip = netstats.get_internal_ip
external_ip = netstats.get_external_ip
txrx = netstats.get_txrx_totals
if options[:wifi] then
  access_point = netstats.get_access_point
else
  access_point = "none"
end
if external_ip == "none" then
  ping_time = "No network"
else
  ping_time = netstats.get_response_time
end

output = 
<<-EOS
 Internal IP : #{internal_ip}
 External IP : #{external_ip}
   Interface : #{iface}
       TX:RX : #{txrx}
Access Point : #{access_point}
   Ping Time : #{ping_time} (#{ping_server})
EOS
puts output
