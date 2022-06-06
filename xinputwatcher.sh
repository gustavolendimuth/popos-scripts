#!/bin/bash
while true
do
  if [[ $(xinput list --name-only | grep 'Basilisk X HyperSpeed Mouse') ]];
  then
    if [[ $(systemctl --user is-active imwheel) == inactive ]];
    then
      systemctl --user start --now imwheel
      echo "starting imwheel"
    else
      echo "imwheel already running"
    fi
  else
    if [[ $(systemctl --user is-active imwheel) == active ]];
    then
      systemctl --user stop --now imwheel
      echo "stopping imwheel"
    else
      echo "imwheel already stopped"
    fi
  fi
  sleep 3
done
