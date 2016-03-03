command: "/path/to/calendar.rb --options"
refreshFrequency: 60000

render: (output) -> """
#{output}
"""

# top center of a 1920x1200 screen, adjust as needed
style: """
margin-left: auto;
margin-right: auto;
width: 100%;
text-align: center;
top: 5px;
color: #777;
font-family: 'Anonymous Pro for Powerline', monospace;
font-size: 12px;
"""
