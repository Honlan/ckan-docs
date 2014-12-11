#!/bin/sh
#还原CKAN备份数据，包括四方面内容
#ckan_default datastore_default 上传文件资源目录 搜索引擎索引目录
service jetty stop
service apache2 stop
server="242"
tday="20141211115337"
dropdb -U postgres ckan_default
dropdb -U postgres datastore_default
createdb -U postgres -O ckan_default ckan_default -E utf-8
createdb -U postgres -O ckan_default datastore_default -E utf-8
. /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src/ckan
paster datastore set-permissions postgres -c /etc/ckan/default/development.ini
psql -U postgres ckan_default < /mnt/ckan/"$server"/"$tday"/ckan_default.sql
psql -U postgres datastore_default < /mnt/ckan/"$server"/"$tday"/datastore_default.sql
cd /var/lib/ckan
rm -r default
tar xzvf /mnt/ckan/"$server"/"$tday"/default.tar.gz default/
cd /var/lib/solr
rm -r data
tar xzvf /mnt/ckan/"$server"/"$tday"/data.tar.gz data/
service jetty start
service apache2 start