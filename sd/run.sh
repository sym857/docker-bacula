docker run -d -h unraid1.satkinson.co.uk --name=bacula-sd -e BACULA_USER=nobody -e BACULA_GRP=users -v /:/data -v $(pwd)/config:/etc/bacula -p 9103:9103 $1
