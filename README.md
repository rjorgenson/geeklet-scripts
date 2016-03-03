# Geeklet Scripts

## A collection of scripts for use with [GeekTool](http://projects.tynsoe.org/en/geektool/) or [Übersicht](http://tracesof.net/uebersicht/)

For best results using these scripts with geektool you should use a [fixed width font](https://en.wikipedia.org/wiki/Monospaced_font).

### calendar.rb

```
Usage: calendar.rb [options]
    -v, --vertical                   Orients the calendar vertically instead of horizontally
    -i, --indicator INDICATOR        The string used to denote which day it currently is on the separator (should be 2 characters)
    -z, --colorize                   indicate the current day with color
    -c, --color COLOR                Sets the color to use as the current day marker (black, red, green, yellow, blue, magenta, cyan, white)
    -C, --hicolor                    Uses the hicolor ASCII value for the chose color
    -t, --colordate                  Use color to mark the date (01, 02, 03)
    -d, --colorday                   Use color to mark the day (Mo, Tu, We)
    -S, --noseparator                Do not output the separator line between days and dates
    -H, --html                       Output HTML color codes instead of shell for use with Ubersicht - requires HTMLEntities gem
    -h, --help                       Displays this help dialogue
```

### battery.rb
```
Usage: battery.rb [options]
    -c, --color                      Display battery meter with color
    -s, --size SIZE                  Size (small, big, bigger) of battery meter
    -H, --html                       Output HTML color codes instead of shell for use with Ubersicht
    -h, --help                       Displays this help screen
```
### netstats.rb
```
Usage: netstats.rb [options]
    -i, --iface IFACE                Set iface to monitor
    -w, --wifi                       iface is a wireless access point
    -s, --server                     set the server to gauge ping response[google.com]
    -H, --html                       Output HTML color codes instead of shell for use with Ubersicht
    -h, --help                       Displays this help screen
```

### date.rb
```
Usage: date.rb [string type]
    -t, --type TYPE                  Date string type to output (long, short, time, longDate, shortDate, string)
    -s, --string "STRING"            UNIX date string to output
    -h, --help                       Displays this help screen
```
