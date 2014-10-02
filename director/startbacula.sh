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

if test -r /etc/bacula/mysql.created
then
   echo "Marker that Mysql already setup"
   rm /setup-mysql.sh
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

/usr/libexec/webmin/changepass.pl /etc/webmin root $WEBMIN_PASSWORD


if test -r /etc/bacula/email.dest
then
   mv /etc/aliases /etc/aliases.old
   grep -v "root:" /etc/aliases.old > /etc/aliases
   echo "root: $(cat /etc/bacula/email.dest)" >> /etc/aliases
   newaliases

   echo "Starting email"
   service postfix start
fi

echo "-------  PS List ---------"
ps -ax
echo "--------------------------"

if test -r /etc/bacula/testemail
then
   echo "Sending a test email"
   echo "test email for bacula director docker" > /email.txt
   echo "." >> /email.txt
   mail -s "Test email from bacula-dir docker" root < /email.txt
   rm /email.txt 
fi

# Start webmin in backgroud
/sbin/service webmin start

# Start Director in foreground
bacula-dir -f -u $BACULA_USER -g $BACULA_GRP -c /etc/bacula/bacula-dir.conf

