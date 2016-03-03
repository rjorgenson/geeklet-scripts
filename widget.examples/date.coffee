command: "/path/to/date.rb --options"
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
top: 40px;
color: #777;
font-family: 'HelveticaNeue-CondensedBold';
font-size: 60 px;
"""
