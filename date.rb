#!/usr/bin/env ruby

require 'open-uri'
require 'optparse'
options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: date.rb [string type]"
  
  options[:type] = 'long'
  opts.on( '-t TYPE', '--type TYPE', 'Date string type to output (long, short, time, longDate, shortDate, string)' ) do |type|
    options[:type] = type
  end

  options[:string] = ''
  opts.on( '-s "STRING"', '--string "STRING"', 'UNIX date string to output') do |string|
    options[:string] = string
  end

  opts.on( '-h', '--help', 'Displays this help screen' ) do
    puts opts
    exit
  end
end

parser.parse!

class Datetime
  def long # Tuesday, September 23 11:11 PM
    return Time.now.strftime("%A, %B %d %I:%M %p")
  end # def long
  
  def short # Tue, Sep 23 11:11 PM
    return Time.now.strftime("%a, %b %d %I:%M %p")
  end # def short
  
  def time # 11:11 PM
      #    future support for time zones and possibly world clocks!
#    ENV['TZ']='America/Chicago'
    return Time.now.strftime("%I:%M %p")
  end # def time
  
  def longDate # Tuesday, September 23
    return Time.now.strftime("%A, %B %d")
  end # def longDate
  
  def shortDate # Tue, Sep 23
    return Time.now.strftime("%a, %b %d")
  end # def shortDate
  
  def string(string)# Returns the interpereted value of string
    return Time.now.strftime(string) 
  end # def string
end # class DateTime

time = Datetime.new
if options[:type] == nil then
  puts time.long
else
  case options[:type]
  when "long"
    puts time.long
  when "short"
    puts time.short
  when "time"
    puts time.time
  when "longDate"
    puts time.longDate
  when "shortDate"
    puts time.shortDate
  when "string"
    if options[:string] == nil then
      puts "Please enter a date format string"
    else
      puts time.string(options[:string])
    end # if options[:string] == nil
  else
    puts time.long
  end # case options[:type]
end # if options[:type] == nil