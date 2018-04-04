#!/bin/sh

# This script bootstraps a VNC environment for new connections.
# It receives a port number as first argument on which the VNC
# server should listen.

while [[ ${1:0:1} == - ]]; do
  [[ $1 =~ ^-h|--help ]] && {
    cat <<-EOF
USAGE: $(basename $0) [OPTIONS] [TEXT]

OPTIONS

  -h  Display help message
EOF
    exit;
  };

  [[ $1 == -- ]] && { shift; break; };

  break;
done

PORT=$1
DISPLAY=""

FBFILE=$(mktemp /tmp/.vncbootstrap-fb-XXXXXX)
AUTHSOCKET=$(mktemp /tmp/.vncbootstrap-auth-XXXXXX)

# Start X Server
exec 6<> ${FBFILE}
/usr/bin/X -displayfd 6 -auth ${AUTHSOCKET} &
exec 6<&- # close file
while [ ${DISPLAY} == "" ]; do
  DISPLAY=$(cat ${FBFILE})
done
echo "X server display: ${DISPLAY}"

# Start VNC Server
/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -rfbport ${PORT} \
                -display ${DISPLAY} -auth ${AUTHSOCKET} -ncache 10
