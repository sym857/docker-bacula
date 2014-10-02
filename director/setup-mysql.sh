#!/bin/bash

/usr/libexec/bacula/grant_mysql_privileges -h $MYSQL_IPADDRESS -u root -p$MYSQL_PASSWORD
/usr/libexec/bacula/create_mysql_database -h $MYSQL_IPADDRESS -u root -p$MYSQL_PASSWORD
/usr/libexec/bacula/make_mysql_tables -h $MYSQL_IPADDRESS -u root -p$MYSQL_PASSWORD
/usr/libexec/bacula/grant_bacula_privileges -h $MYSQL_IPADDRESS -u root -p$MYSQL_PASSWORD

echo "use mysql;" > /mysql.sql
echo "UPDATE user SET password=PASSWORD(\"$MYSQL_PASSWORD\") WHERE user='bacula';" >> /mysql.sql
echo "FLUSH PRIVILEGES;" >> /mysql.sql
echo "exit" >> /mysql.sql

touch /etc/bacula/mysql.created

mysql -h $MYSQL_IPADDRESS -u root -p$MYSQL_PASSWORD < /mysql.sql


 

