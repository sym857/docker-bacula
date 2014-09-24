#!/bin/bash

SLEEPDELAY_ONWAKE=45
SLEEPDELAY_ONSLEEP=45
BCASTADDRESS=192.168.3.255
FQDNTOMACFILE=/etc/hostmacs
STATEFILES=/tmp
RETRIES=5
REMOTESLEEPCOMMAND=/home/steve/gotosleep.sh
INTERFACE=eth0

OPT_DEBUG=1


function showHelp
{
   echo "$0 <MODE> <fqdn>"
   exit 1
}

function debug
{
        if test $OPT_DEBUG -eq 1
        then
                logger "skawake : $1 $2 $3 $4 $5 $6 $7 $8 $9"
        fi
}

function output
{
   logger "skawake : $1 $2 $3 $4 $5 $6 $7 $8 $9"
}




function isAwake
{
    ping -i 0.5 -w 1 -c 2 $1 | grep " 0%" > /dev/null
    if test $? -eq 0  
    then
       return 1
    else
       return 0
    fi
}

function triggerSleep
{
   host=$1
   force=$2
   output "Request to put $host to sleep"
   if test $force -eq 0
   then 
      if test -r $STATEFILES/$host
      then
         if test "$(cat $STATEFILES/$host)" = "AWAKE"
         then
            output "Server was already awake not putting it to sleep"
            exit 0
         fi
      fi
   fi
   output "Commanding $host to have a nap"
   ssh steve@$host $REMOTESLEEPCOMMAND &
   sleep 15
   KILLSSH="$(ps ax | grep gotosleep.sh | grep -v grep | cut -d ' ' -f 1)"
   kill -9 $KILLSSH
   output "I attempted to kill PID $KILLSSH"
   output "Waiting before checking status of $host"
   sleep $SLEEPDELAY_ONSLEEP
   isAwake $host
   if test $? -eq 1
   then
      output "Failed to put $host to sleep"
      exit 1
   else
      output "Success $host is sleeping"
      exit 0
   fi
}

function triggerWake
{
   host=$1
   output "Request to wake $host"
   output "Searching for $host in MAC Address map"
   MAC=$(grep "$host" $FQDNTOMACFILE | cut -d ' ' -f 2)
 
   if test "$MAC" = "" 
   then
       output "Not MAC address mapped for $host"
       exit 1
   fi  
   isAwake $host
   if test $? -eq 1
   then 
       echo "AWAKE" > $STATEFILES/$host
       output "$host Already awake"
       exit 0
   else 
       echo "SLEEP" > $STATEFILES/$host
   fi 

   let count=$RETRIES
   while(test $count -gt 0)
   do
       output "Attempting to wake $host $MAC"
       ether-wake -i $INTERFACE $MAC
       
       output "Wait for $SLEEPDELAY_ONWAKE"
       sleep $SLEEPDELAY_ONWAKE

       isAwake $host
       if test $? -eq 1
       then 
           output "$host has woken"
           exit 0
       fi
       let count=$count-1
   done
   output "Failed to wake $host"
   exit 1
}

# MAIN
if test $# -ne 2
then
   showHelp
fi

if test $(id -u) -ne 0
then
   output "You must be root to run this"
   exit 1
fi

case "$1" in 
   "SLEEP") triggerSleep $2 0;;
   "sleep") triggerSleep $2 0;;
   "forcesleep") triggerSleep $2 1;;
   "FORCESLEEP") triggerSleep $2 1;;
   "WAKE")  triggerWake $2;;
   "wake")  triggerWake $2;;
   *)  showHelp;;
esac


   




