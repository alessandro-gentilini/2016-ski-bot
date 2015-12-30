#!/usr/bin/python

# Allowing less secure apps to access your account
# http://www.google.com/settings/security/lesssecureapps
# "Less secure apps access" must be enabled!

def send_email(sender,password,recipient,subject,body):
	# Import smtplib for the actual sending function
	import smtplib

	# Import the email modules we'll need
	from email.mime.text import MIMEText

	# Create a text/plain message
	msg = MIMEText(body)
	
	msg['Subject'] = subject
	msg['From'] = sender
	msg['To'] = recipient

	# Send the message via our own SMTP server, but don't include the
	# envelope header.
	s = smtplib.SMTP('smtp.gmail.com:587')
	s.ehlo()
	s.starttls()

	s.login(sender,password)
	s.sendmail(msg['From'], msg['To'], msg.as_string())
	s.quit()

import sys

send_email(sys.argv[1],sys.argv[2],sys.argv[3],'subject','body')
