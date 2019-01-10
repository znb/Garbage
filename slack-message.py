#!/usr/bin/python
# Script to enumerate Slack from an API key
# Requirements: https://github.com/slackapi/python-slackclient


import sys
import os
import signal
import argparse
try:
    from slackclient import SlackClient
except:
    sys.exit("[ERROR] Unable to import SlackClient")

parser = argparse.ArgumentParser(description='DESCRIPTION HERE')
parser.add_argument('--channel', '-c', dest='channel', help='stuff')
parser.add_argument('--message', '-m', dest='message', help='things')
args = parser.parse_args()
CHANNEL = args.channel
MESSAGE = args.message


def sighandle(signal, frame):
    """Catch Ctrl-C"""
    sys.exit(0)


print "\nChannel: " + CHANNEL
print "Message: " + MESSAGE
signal.signal(signal.SIGINT, sighandle)
c = raw_input("\nCtrl-C to exit..otherwise we send >> ")
print "Sending.."

try:
    slack_token = os.environ["SLACK_API_TOKEN"]
except KeyError:
    sys.exit("[ERROR] No API key exported")
sc = SlackClient(slack_token)


sc.api_call(
  "chat.postMessage",
  channel=CHANNEL,
  text=MESSAGE
)