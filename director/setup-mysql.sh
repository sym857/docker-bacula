#!/bin/bash

/usr/libexec/bacula/grant_mysql_privileges -u root -p$MYSQL_PASSWORD
/usr/libexec/bacula/create_mysql_database -u root -p$MYSQL_PASSWORD
/usr/libexec/bacula/make_mysql_tables -u root -p$MYSQL_PASSWORD
/usr/libexec/bacula/grant_bacula_privileges -u root -p$MYSQL_PASSWORD

echo "use mysql;" > /mysql.sql
echo "UPDATE user SET password=PASSWORD(\"$MYSQL_PASSWORD\") WHERE user='bacula';" >> /mysql.sql
echo "FLUSH PRIVILEGES;" >> /mysql.sql
echo "exit" >> /mysql.sql

mysql -u root -p$MYSQL_PASSWORD < /mysql.sql


 

