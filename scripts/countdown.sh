#!/bin/bash

# This script was copied from:
# https://serverfault.com/questions/532559/bash-script-count-down-5-minutes-display-on-single-line

s="${1}"
if [[ "$s" =~ ([0-9]+)m ]]; then
    let s=${BASH_REMATCH[1]}*60
fi

Floor () {
  DIVIDEND=${1}
  DIVISOR=${2}
  RESULT=$(( ( ${DIVIDEND} - ( ${DIVIDEND} % ${DIVISOR}) )/${DIVISOR} ))
  echo ${RESULT}
}

Timecount(){
        s=${1}
        HOUR=$( Floor ${s} 60/60 )
        s=$((${s}-(60*60*${HOUR})))
        MIN=$( Floor ${s} 60 )
        SEC=$((${s}-60*${MIN}))
     while [ $HOUR -ge 0 ]; do
        while [ $MIN -ge 0 ]; do
                while [ $SEC -ge 0 ]; do
                        printf "%02d:%02d:%02d\033[0K\r" $HOUR $MIN $SEC
                        SEC=$((SEC-1))
                        sleep 1
                done
                SEC=59
                MIN=$((MIN-1))
        done
        MIN=59
        HOUR=$((HOUR-1))
     done
}

m=$s-1 # add minus 1 
Timecount $m

