#!/usr/bin/env bash

function start_vnc() {
  # Start the window manager (login screen)
  echo "Starting Window Manager"
  sddm &
  SDDMPID=$!

  # Get the auth file from the WM
  echo "Waiting for WM to finish"
  while [ $(ps ax | grep /var/run/sddm | grep X | wc -l) -lt 1 ];
  do
    sleep 1
  done

  echo "Obtaining X authentication location"
  AUTHFILE=$(ps ax | grep /var/run/sddm | grep X | awk '{print $9}')

  # Start x11vnc
  echo "Starting x11vnc"
  /usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :0 -o /var/log/x11vnc.log -auth ${AUTHFILE}

  # Ensure all subprocesses (including X) are killed
  kill -TERM ${SDDMPID}
}

echo "Accepting VNC connections"
while [ 1 == 1 ];
do
  start_vnc
  echo "VNC connection closed $(date)"
done
