#!/usr/bin/env python3
#
# Retrieve and print the latest email.
#
# based on:
# https://askubuntu.com/questions/573452/how-to-read-user-last-email-using-a-shell-script
# and:
# http://bruno.im/2009/dec/18/decoding-emails-python/
#
# author: andreasl

import email
import imaplib
import sys
from email.header import decode_header
from email.parser import Parser

# Add your data here
IMAP_HOST     = sys.argv[1]
MAIL_USERNAME = sys.argv[2]
MAIL_PASSWORD = sys.argv[3]

server = imaplib.IMAP4_SSL(IMAP_HOST)
server.login(MAIL_USERNAME, MAIL_PASSWORD)
server.select("INBOX", readonly=True)
_, data = server.search(None, "ALL")  # search emails
ids = data[0]  # data is a list.
id_list = ids.split()  # ids is a space separated string
latest_email_id = id_list[-1]  # get the latest
_, mail_data = server.fetch(latest_email_id, "(RFC822)")  # fetch email

for response_part in mail_data:
    if isinstance(response_part, tuple):
        msg = email.message_from_bytes(response_part[1])
        date = msg["Date"]
        sender = msg["from"]
        subject_header = decode_header(msg["subject"])[0]
        subject = subject_header[0].decode(subject_header[1])

        print(f"From: {sender}")
        print(f"Date: {date}")
        print(f"Subject: {subject}")

        p = Parser()
        message = p.parsestr(msg.as_string())

        for part in message.walk():
            charset = part.get_content_charset()
            if (
                part.get_content_type() == "text/plain"
                or part.get_content_type() == "text/html"
            ):
                part_str = part.get_payload(decode=1)
                print(part_str.decode(charset))

server.close()
server.logout()
