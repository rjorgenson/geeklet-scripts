command: "/path/to/netstats.rb --options"
refreshFrequency: 60000

render: (output) -> """
#{output}
"""

# top left of a 1920x1200 screen, adjust as needed
style: """
text-align: left;
top: 5px;
color: #777;
font-family: 'Anonymous Pro for Powerline', monospace;
font-size: 13px;
"""
