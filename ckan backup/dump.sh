#!/bin/sh
#备份CKAN，包括四个方面的内容
#ckan_default datastore_default 上传文件资源目录 搜索引擎索引目录
#server为服务器文件夹名称，如在242上操作则备份至242文件夹
#tday为当前时间
#数据库用pg_dump命令生成sql，文件夹用tar命令打包
server="242"
tday=`date +%Y%m%d%H%M%S`
mkdir /mnt/ckan/"$server"/"$tday"
pg_dump ckan_default -U postgres > /mnt/ckan/"$server"/"$tday"/ckan_default.sql
pg_dump datastore_default -U postgres > /mnt/ckan/"$server"/"$tday"/datastore_default.sql
cd /var/lib/ckan/
tar czvf /mnt/ckan/"$server"/"$tday"/default.tar.gz default/
cd /var/lib/solr/
tar czvf /mnt/ckan/"$server"/"$tday"/data.tar.gz data/