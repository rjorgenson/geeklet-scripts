#!/usr/bin/env ruby
#coding: utf-8

require 'optparse'
require 'date'

options = {}

# grab command line arguments
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: calendar.rb [options]'
  
  options[:vertical] = false 
  opts.on( '-v', '--vertical', 'Orients the calendar vertically instead of horizontally') do
    options[:vertical] = true
  end
  
  options[:indicator] = '◆◆'
  opts.on( 'i INDICATOR', '--indicator INDICATOR', 'The string used to denote which day it currently is on the separator (should be 2 characters)') do |indicator|
    options[:indicator] = indicator
  end
  
  options[:colorize] = false
  opts.on( '-C', '--colorize', 'indicate the current day with color') do
    options[:colorize] = true
  end
  
  options[:color] = 'green'
  opts.on( '-c COLOR', '--color COLOR', [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white], 'Sets the color to use as the current day marker (black, red, green, yellow, blue, magenta, cyan, white)') do |color|
    options[:color] = color
  end
  
  options[:hicolor] = false
  opts.on( '-C', '--hicolor', 'Uses the hicolor ASCII value for the chose color') do
    options[:hicolor] = true
  end
  
  options[:colordate] = false
  opts.on( '-d', '--colordate', 'Use color to mark the date (01, 02, 03) - horizontal only') do
    options[:colordate] = true
  end
  
  options[:colorday] = false
  opts.on( '-d', '--colorday', 'Use color to mark the day (Mo, Tu, We) - horizontal only') do
    options[:colorday] = true
  end

  options[:noseparator] = false
  opts.on( '-S', '--noseparator', 'Do not output the separator line between days and dates') do
    options[:noseparator] = true
  end

  opts.on( '-h', '--help', 'Displays this help dialogue' ) do
    puts opts
    exit
  end
end

parser.parse!

class Line_Calendar
  # set up some constants for use in throughout the script
  SEPARATOR_STRING_A = "  " # the string used to separate days and dates
  SEPARATOR_STRING_B = "··" # the string used between seperators
  SEPARATOR_STRING_C = "··" # the separator string
  END_COLOR = "\e[0m" # this string ends color output
  HI_COLOR = "\e[1m" # this string denotes bold color
  ABBR_DAYNAMES = {0 =>  'Su', 1 => 'Mo', 2 => 'Tu', 3 => 'We', 4 => 'Th', 5 => 'Fr', 6 => 'Sa'} # map of abbreviated day names to matching index for date functions
  # hash of the different colors available as ASCII output
  COLORS = {'black' => "\e[30m", 'red' => "\e[31m", 'green' => "\e[32m", 'yellow' => "\e[33m", 'blue' => "\e[34m", 'magenta' => "\e[35m", 'cyan' => "\e[36m", 'white' => "\e[37m"}

  def initialize(opts)
    @options = opts
  end

  # returns intiger with number of days in the month (28, 29, 30, 31)
  def days_in_month(year, month)
    return (Date.new(year, 12, 31) << (12 - month)).day
  end
  
  # returns what day of the month it is (1-31)
  def day_in_month(year, month, day)
    return Date.new(year, month, day).wday
  end
  
  # returns an array of days in the month (Mo, Tu, We, etc.)
  def build_day_array(year, month)
    day_array = Array.new
    # cycle through number of days in the month and build an array with one entry per day
    for d in (1..self.days_in_month(year, month))
      day_array[d] = Line_Calendar::ABBR_DAYNAMES[self.day_in_month(year, month, d)] # populates array with abbreviated daynames
    end
    # remove the 0 entry and move everything up one
    day_array.shift
    return day_array
  end
  
  # builds the separator line between the days and dates
  def build_separator(year, month)
    separator = Array.new
    # cycle through days in month
    for d in (1..self.days_in_month(year, month))
      # does this match today?
      if year == Time.now.year && month == Time.now.month && d == Time.now.day then
        separator[d.to_i] = @options[:indicator]
      else
        # append separator to the array
        separator[d.to_i] = Line_Calendar::SEPARATOR_STRING_B
      end
    end
    # trim 0 key and move everything up one
    separator.shift
    return separator
  end
  
  # build array of dates (1-31)
  def build_date_array(year, month)
    date_array = Array.new
    # cycle through days in month creating one key in the array for each day
    for d in (1..self.days_in_month(year, month))
      if d.to_i < 10 then
        # if date is 1-9 make sure it is 01-09
        d = "0#{d}"
      end
      date_array[d.to_i] = d
    end
    # remove 0 key for 1 to 1 mapping in array
    date_array.shift
    return date_array
  end

  # build array vertically instead of horizontally
  def build_vertical_array(year, month)
    # pull in arrays of days and dates
    dates = self.build_date_array(Time.now.year, Time.now.month)
    days = self.build_day_array(Time.now.year, Time.now.month)
    
    # zip the two arrays so we have the following single array to work with
    # [['Mo', '01'], ['Tu', '02']]
    vertical = days.zip(dates)

    return vertical
  end

  def colorize_days(days)
    # implement method to make the day (Mo, Tu, We) colorized
    count = 1
    days.each do |d|
        if Time.now.day == count then
            days[count -1] = Line_Calendar::COLORS[@options[:color].to_s] + d + Line_Calendar::END_COLOR
        end
        count += 1
    end
    return days
  end

  def colorize_separator(sep) # add color to the separator day indicator
    count = 1 # seed to keep track of where we are in the array
    sep.each do |s|
      # if it's today, add color and replace string in array
      if Time.now.day == count then
          sep[count -1] = Line_Calendar::COLORS[@options[:color].to_s] + @options[:indicator] + Line_Calendar::END_COLOR
      end
      # increment counter
      count += 1
      # loop de loop until finished
    end
    # return new array with colorized strings added
    return sep
  end

  def colorize_dates(dates)
    # implement method to make the date (01, 02, 03) colorized
    count = 1
    dates.each do |d|
        if Time.now.day == count then
            dates[count -1] = Line_Calendar::COLORS[@options[:color].to_s] + d.to_s + Line_Calendar::END_COLOR
        end
        count += 1
    end
    return dates
  end
end

cal = Line_Calendar.new(options) # pass command line args to object
year = Time.now.year # current year
month = Time.now.month # current month
  
# print out vertically
if options[:vertical] then
  # build and grab relevant information in a hash ( Mo => 01, Tu => 02 )
  varray = cal.build_vertical_array(year, month)
  # foreach entry in array
  varray.each do |d|
    # if no separator was requested, don't print one
    if options[:noseparator] then
      # each hash pair printed out separated by spaces
      puts d[0].to_s + Line_Calendar::SEPARATOR_STRING_A + d[1].to_s
    elsif Time.now.year == year && Time.now.month == month && d[1].to_i == Time.now.day then
      # is it today?
      if options[:colorize] then
        # add color and indicator if requested
        puts d[0].to_s + Line_Calendar::SEPARATOR_STRING_A + Line_Calendar::COLORS[options[:color].to_s] + options[:indicator] + Line_Calendar::END_COLOR + Line_Calendar::SEPARATOR_STRING_A + d[1].to_s
      else
        # otherwise just add indicator
        puts d[0].to_s + Line_Calendar::SEPARATOR_STRING_A + options[:indicator] + Line_Calendar::SEPARATOR_STRING_A + d[1].to_s
      end
    else
      # not today, no indication required
      puts d[0].to_s + Line_Calendar::SEPARATOR_STRING_A + Line_Calendar::SEPARATOR_STRING_C + Line_Calendar::SEPARATOR_STRING_A + d[1].to_s
    end
  end
else
# print out horizontally
  
  # each day (Mo, Tu, We) separated by spaces
  if options[:colorday] then  # add color indicating day
    puts cal.colorize_days(cal.build_day_array(year, month)) * Line_Calendar::SEPARATOR_STRING_A
  else
    # no color, just output days
    puts cal.build_day_array(year, month) * Line_Calendar::SEPARATOR_STRING_A
  end

  # if no separator requested then don't print one
  if options[:noseparator] then
  # otherwise print one
  else
    # add color if requested
    if options[:colorize] then
      puts cal.colorize_separator(cal.build_separator(year, month)) * Line_Calendar::SEPARATOR_STRING_C
    else
      # plain separator with no color
      puts cal.build_separator(year, month) * Line_Calendar::SEPARATOR_STRING_C
    end
  end

  # each date (01, 02, 03) separated by spaces
  if options[:colordate] then # add color indicating current date
      puts cal.colorize_dates(cal.build_date_array(year, month)) * Line_Calendar::SEPARATOR_STRING_A
  else
      # no color, just output dates
      puts cal.build_date_array(year, month) * Line_Calendar::SEPARATOR_STRING_A
  end
end
