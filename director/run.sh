docker run -d -h backup.satkinson.co.uk --name=bacula-dir -e BACULA_USER=nobody -e BACULA_GRP=users -e MYSQL_PASSWORD=S3cr3tSqu1rr3l -v /:/data -v $(pwd)/config:/etc/bacula -v $(pwd)/mysql:/var/lib/mysql -v $(pwd)/spool:/var/spool/bacula -p 9101:9101  -p 10000:10000 -p 3306:3306 $1
