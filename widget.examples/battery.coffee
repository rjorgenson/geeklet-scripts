command: "/path/to/battery.rb --options"
refreshFrequency: 10000

render: (output) -> """
#{output}
"""

# bottom right corner of a 1920x1200 screen, adust as needed
style: """
text-align: right;
width: 100%;
top: 1165px;
color: #777;
font-family: 'Anonymous Pro for Powerline', monospace;
font-size: 12px;
"""
