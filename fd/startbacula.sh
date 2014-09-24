#!/bin/bash

if test -r /etc/bacula/hosts 
then
    cat /etc/bacula/hosts > /etc/hosts
fi

if test -r /etc/bacula/resolv.conf 
then
    cat /etc/bacula/resolv.conf > /etc/resolv.conf
fi

bacula-fd -f -u $BACULA_USER -g  $BACULA_GRP -c /etc/bacula/bacula-fd.conf

