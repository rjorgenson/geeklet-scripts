#!/usr/bin/env ruby
# include option parsing library
require 'optparse'
options = {}

# grab command line arguments
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: battery.rb [options]'

  options[:color] = false
  opts.on('-c', '--color', 'Display battery meter with color') do
    options[:color] = true
  end

  options[:size] = 'small'
  opts.on('-s SIZE', '--size SIZE', %i[small big bigger], 'Size (small, big, bigger) of battery meter') do |size|
    options[:size] = size
  end

  options[:cell] = '❚'
  opts.on('-l CELL', '--cell CELL', 'The character to use for each battery cell') do |cell|
    options[:cell] = cell
  end

  options[:html] = false
  opts.on('-H', '--html', 'Out put HTML color codes instead of shell') do
    options[:html] = true
  end

  options[:map] = false
  opts.on('-m MAP', '--map MAP',
          'Key:Value mapping of device names to display names, separated by a semicolon (;)' \
          ' [Magic Keyboard with Numeric Keypad:Keyboard]') do |map|
    options[:map] = map
  end

  options[:separator] = "\n"
  opts.on('-S SEPARATOR', '--separator SEPARATOR',
          'Split multiple batteries by this string (default \'\n\')') do |separator|
    options[:separator] = separator
  end

  opts.on('-h', '--help', 'Displays this help screen') do
    puts opts
    exit
  end
end

parser.parse!

class Battery
  # gather relevant info
  def initialize(opts)
    @options = opts
    @options[:separator] = '<br />' if @options[:html] && @options[:separator] == "\n"
    if @options[:map]
      @map = {}
      @options[:map].split(';').each do |device|
        @map[device.split(':')[0]] = device.split(':')[1]
      end
    end
    @devices = `ioreg -c AppleDeviceManagementHIDEventService -r`.split("\n\n")
  end

  def build_meter(device, color)
    percent = @devices[device].match(/BatteryPercent" = (\d+)/)[1].to_i
    meter = ''
    # case size
    if @options[:size].to_s == 'small'
      blength = 10
      bpercent = 10
      bred = 1
      byellow = 3
      bgreen = 10
    elsif @options[:size].to_s == 'big'
      blength = 20
      bpercent = 5
      bred = 2
      byellow = 6
      bgreen = 20
    else
      blength = 50
      bpercent = 2
      bred = 5
      byellow = 15
      bgreen = 50
    end

    if color
      if @options[:html]
        red = "<span style='color:red'>"
        yellow = "<span style='color:yellow'>"
        green = "<span style='color:green'>"
        clear = '</span>'
      else
        red = "\e[31m"
        yellow = "\e[33m"
        green = "\e[32m"
        clear = "\e[0m"
      end
    else
      red = ''
      yellow = ''
      green = ''
      clear = ''
    end

    (1..blength).each do |i|
      if percent >= bpercent
        i <= bred ? meter << red : nil # first 2 bars red
        i <= byellow && i > bred ? meter << yellow : nil # next 3 bars yellow
        i <= bgreen && i > byellow ? meter << green : nil # remaining 5 green
        meter << @options[:cell] + clear # clear color
      else
        meter << '·' # empty
      end
      percent -= bpercent # decrement percentage for next loop
    end
    meter += "#{percent + 100}%"
    meter + clear
  end

  def build_identifier(device)
    product = @devices[device].match(/Product" = "(.*)"/)
    address = @devices[device].match(/DeviceAddress" = "(.*)"/)
    id = product && product[1] || address && address[1] || 'Unknown'
    id = @map[id].to_s if @map && @map[id]
    id + ': '
  end

  def build_time(device) # determines time remaining on battery
    batTime = ''
    if @devices[device].match(/BatteryStatusFlags" = (\d+)/)[1] == '3'
      batTime = if @devices[device].match(/BatteryPercent" = (\d+)/)[1] == '100'
                  ' (Charged)'
                else
                  ' (Charging)'
                end
    end

    batTime
  end # def build_time

  def display_meters
    meters = []
    for i in (0..@devices.length - 1)
      meters.append(build_identifier(i) + build_meter(i, @options[:color]) + build_time(i).to_s)
    end
    meters.sort.join(@options[:separator])
  end
end # Class Battery

battery = Battery.new(options)

puts battery.display_meters
