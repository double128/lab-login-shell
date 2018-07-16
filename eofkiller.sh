#!/bin/bash
#
# EOF KILLER
# Stops silly naughty boys from invoking CTRL+D. This needs to be done,
# as CTRL+D isn't a signal (like SIGINT) and rather an actual piece of
# data sent to the terminal to invoke an EOF.

for pid in $( pgrep -U $(whoami) ); do
	logger "CTRL+D invoked, killing all login shell PIDs"
	kill -9 $pid
done
