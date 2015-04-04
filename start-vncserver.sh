#! /usr/bin/env bash
# thanks to kolypto @ serverfault for this script.
# since vncserver is running as a daemon, we're creating a foreground process for supervisord.

set -eu

# Setting pidfile + command to execute
pidfile="/root/.vnc/b11ec321727f:1.pid"
command="/usr/bin/vncserver :1 -geometry 1366x768 -depth 24"

USER=root
export USER


# Proxy signals
function kill_app(){
    kill $(cat $pidfile)
    exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

# Launch daemon
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 0.5
done
exit 1000 # exit unexpected
