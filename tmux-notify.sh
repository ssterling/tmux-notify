#!/usr/bin/env sh
# 'tmux-notify' - simple tmux notification script
# Copyright 2017 Seth Price
# Released under the MIT License; see ./LICENSE for details

message_store=${HOME}/.tmux-notify

if [ ! -f $message_store ]; then
    touch $message_store
fi

function tmux_notify_usage {
    read -d '' usage <<- EOF
Usage: `basename $0` [COMMAND | PROGRAM_NAME MESSAGE]

Commands:
  count       Show number of pending notifications
  clear       Clear all notifications
  show        Print notifications and clear
  show-nc     Print notifications (but don't clear)
EOF

    echo "$usage" 1>&2
    exit 1
}

function tmux_notify {
    #notification="[$(date)] $1: $2"
    notification="$1: $2"
    echo $notification >> $message_store

    tmux_window=$(/usr/bin/tmux list-windows \
        -F "#{window_active} #{window_index} #{window-name}" | \
        sort | tail -n 1 | cut -d ' ' -f 2-)

    # TODO: reset this to initial value later?
    tmux set-option -t ${tmux_window} display-time 4000
    tmux display-message "${notification}"
    return $?
}

function tmux_notify_count {
    if [ -e $message_store ]; then
        message_count=$(wc -l ${message_store} | awk '{ print $1 }')
    else
        message_count=0
    fi
    echo $message_count
}

function tmux_notify_clear {
    if [ -e $message_store ]; then
        rm $message_store && touch $message_store
    else
        touch $message_store
    fi
    return $?
}

if [ "$1" == "count" ]; then
    echo $(tmux_notify_count)
elif [ "$1" == "clear" ]; then
    tmux_notify_clear
elif [ "$1" == "show" ]; then
    cat $message_store
    tmux_notify_clear
elif [ "$1" == "show-nc" ]; then
    cat $message_store
elif [ "$#" -eq 2 ]; then
    tmux_notify $*
else
    tmux_notify_usage
fi
