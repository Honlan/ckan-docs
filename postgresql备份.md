# PostgreSQL备份

备份 PostgreSQL 数据有三种完全不同的方法：

* SQL 转储
* 文件系统级别备份
* 在线备份

每种备份都有自己的优点和缺点。

## SQL转储

### pg_dump

	pg_dump dbname > outfile

	psql dbname < infile

以上命令均在shell命令行中运行，可以使用pg_dump --help查看使用方法，备份时需要提供数据库名、端口、主机等参数。

由pg_dump创建的备份在内部是一致的， 也就是说，在pg_dump运行的时候对数据库的更新将不会被转储。 pg_dump 工作的时候并不阻塞其他的对数据库的操作。

pg_dump和psql可以通过管道读写， 这样我们就可能从一台主机上将数据库目录转储到另一台主机上，比如：

	pg_dump -h host1 dbname | psql -h host2 dbname

### pg_dumpall

pg_dumpall 备份一个给出的集群中的每个数据库，同时还确保保留象用户和组这样的全局数据状态：

	pg_dumpall > outfile

	psql -f infile postgres

### 处理大数据库

使用压缩的转储，例如gzip：

	pg_dump dbname | gzip > filename.gz

	createdb dbname
	gunzip -c filename.gz | psql dbname

或者使用以下命令恢复gzip：
    
    cat filename.gz | gunzip | psql dbname

还可以使用spilt将输出分解为操作系统可以接受的大小，如每块1M：
	
	pg_dump dbname | split -b 1m - filename
	
	createdb dbname
	cat filename* | psql dbname
	
## 文件系统级别备份

如果知道PostgreSQL数据库的存放位置，可以考虑直接拷贝并压缩数据文件：

	tar -cf backup.tar /usr/local/pgsql/data
	
但显然这种方法远不如使用PostgreSQL命令备份数据，因为首先为了进行有效的文件备份，数据库服务器必须被关闭，其次数据库文件系统布局相当复杂，并不是简单的拷贝几个数据库文件即可完成备份。
	

## 参考资料

* [pg_dump备份方法](http://rainbow702.iteye.com/blog/1318741)
* [PostgreSQL官网：pg_dump](http://www.postgresql.org/docs/9.2/static/app-pgdump.html)