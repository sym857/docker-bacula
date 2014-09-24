docker run -d -h unraid1.satkinson.co.uk --name=bacula-fd -e BACULA_USER=nobody -e BACULA_GRP=users -v /:/data -v $(pwd)/config:/etc/bacula -p 9102:9102 $1
