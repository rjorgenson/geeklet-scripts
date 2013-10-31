#!/usr/bin/env ruby

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
if ARGV[0] == nil then
  puts time.long
else
  case ARGV[0]
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
    if ARGV[1] == nil then
      puts "Please enter a date format string"
    else
      puts time.string(ARGV[1])
    end # if ARGV[2] == nil
  else
    puts time.long
  end # case ARGV[1]
end # if ARGV[1] == nil
