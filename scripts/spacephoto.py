#######################################################################
## spacephoto.py - script for downloading space photo of the day!
##
## Copyright (C) 2012 Matthew J. Lenzo
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see http://www.gnu.org/licenses/.
#######################################################################

import os
import sys
import feedparser
import urllib2
import concurrent.futures
from pytz import timezone, utc
from datetime import datetime, timedelta, date
from bs4 import BeautifulSoup
from optparse import OptionParser

default_dest = "images/"

# Check command-line arguments
parser = OptionParser("usage: %prog [options]")
parser.add_option("-d", "--days",
                  action="store",
                  type="int",
                  default=1,
                  dest="days",
                  help="days worth of images to download " + \
                  " [default: %default]")

parser.add_option("-o", "--out",
                  action="store",
                  type="string",
                  dest="out",
                  default=default_dest,
                  help="destination folder [default: %default]")
(options, args) = parser.parse_args()

if options.days <= 0:
    options.days = 1

# Check output directory
if not os.path.exists(options.out):
    print "{0} does not exist. Creating.".format(options.out)
    os.makedirs(options.out)
print "Downloadingphotos to {0}".format(options.out)

# Calculate back-date for image grabs
tz_eastern = timezone('US/Eastern')
back_date = date.today() - timedelta(days=options.days - 1)
back_date_tz = tz_eastern.localize\
    (datetime(back_date.year, back_date.month, back_date.day))
print "Downloading photos since {0}".format\
    (back_date.strftime('%d, %h %Y %H:%M'))

# Grab 'Wired Space Photo of the Day' RSS feed
url = "http://www.wired.com/wiredscience/tag/" + \
    "space-photo-of-the-day/feed"
feed = feedparser.parse(url)
if feed.bozo:
    print "Feed error"
    sys.exit(0)

def download_img(url):
    file_name = url.split('/')[-1]
    file_size = 0
    if not os.path.exists(options.out + file_name):
        req = urllib2.urlopen(url)
        f = open(options.out + file_name, 'wb')
        meta = req.info()
        file_size = int(meta.getheaders("Content-Length")[0])
        f.write(req.read())
        f.close()
    return (file_name, sizeof_fmt(file_size))

def sizeof_fmt(num):
    for x in ['bytes','KB','MB','GB']:
        if num < 1024.0 and num > -1024.0:
            return "%3.1f%s" % (num, x)
        num /= 1024.0
    return "%3.1f%s" % (num, 'TB')

def fetch(url):
    req = urllib2.urlopen(url)
    html = req.read()
    tags = BeautifulSoup(html)
    for link in tags.find_all("a",text="high-resolution"):
        return download_img(link.get('href'))
    return ("none", sizeof_fmt(0))

def is_valid(entry):
    pub_date = datetime(*entry.published_parsed[0:6])
    pub_date_tz = tz_eastern.localize(pub_date)
    return pub_date_tz >= back_date_tz

with concurrent.futures.ThreadPoolExecutor(max_workers=20) as ex:
    urls = [entry.link 
            for entry in feed.entries
            if is_valid(entry)]
    pool = {ex.submit(fetch, url):url for url in urls}

    for future in concurrent.futures.as_completed(pool):
        url = pool[future]
        try:
            data = future.result()
        except Exception as exc:
            print('%r generated an exception: %s' % (url, exc))
        else:
            print('Downloaded %s : %s' % (data[0], data[1]))
