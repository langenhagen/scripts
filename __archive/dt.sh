#!/bin/bash
#
# A script for working with datetimes and timestamps.
# It can convert given timestamps into human readable dates/times and vice versa.
# It can also work with time offsets.
# The timestamps are returned in milliseconds.
#
# author: andreasl

tims                        # timestamp in milliseconds now
tims 1551375803             # returns the date
tims 1551375803000          # returns the date
tims -10 20 30              # timestamp now - 10 days - 20 hrs - 30 minutes
tims +10 20 30              # timestamp now + 10 days + 20 hrs + 30 minutes
tims 2019 1 2               # timestamp on the 2nd January 2019 local time
tims 19 2 3                 # timestamp on the 3rd February 2019 0:00 local time

# TODO implement
# TODO usage string

if no arg
0
    tims aka
        date +%s000
1
    if timestamp >= 14
        cut 3
    tims timestamp aka
        date -d "@1551375803"
2 if param 1 '+' or '-'
    days=value or 0
    hours=value or 0
    minutes=value or 0
    seconds=value or 0
    tims -10 20 30 aka
        date +%s000 -d "+ 10 days 20 hours 30 minutes"
        date +%s000 -d "- 10 days 20 hours 30 minutes"
else
    year=value or 0
    month=value or 0
    day=value or 0
    hour=value or 0
    minute=value or 0
    second=value or 0
    if year < 100
        add 2000 to year

    date +%s000 -d "2019/02/01 1:01:02"


#how about:
# tims 20438532985 -2d

