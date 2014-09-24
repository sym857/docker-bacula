#!/bin/bash

if test -r /etc/bacula/hosts
then 
   cp /etc/bacula/hosts /etc
fi
if test -r /etc/bacula/ssmtp.conf 
then
   cp /etc/bacula/ssmtp.conf /etc/ssmtp
fi
if test -r /etc/bacula/revaliases
then
   cp /etc/bacula/revaliases /etc/ssmtp
fi
if test -r /etc/bacula/hostmacs
then
   cp /etc/bacula/hostmacs /etc
fi

if test -x /setup-mysql.sh
then
   echo "Setuping up Mysql"
   /setup-mysql.sh
   rm /setup-mysql.sh
else
   echo "Starting Mysql"
   service mysqld start
fi

echo "-------  PS List ---------"
ps -ax
echo "--------------------------"


# Start webmin in backgroud
/sbin/service webmin start

# Start Director in foreground
bacula-dir -f -u $BACULA_USER -g $BACULA_GRP -c /etc/bacula/bacula-dir.conf

