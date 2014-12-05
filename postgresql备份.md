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

由 pg_dump 创建的备份在内部是一致的， 也就是说，在pg_dump运行的时候对数据库的更新将不会被转储。 pg_dump 工作的时候并不阻塞其他的对数据库的操作。

pg_dump 和 psql 可以通过管道读写， 这样我们就可能从一台主机上将数据库目录转储到另一台主机上，比如：

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

## 参考资料

* [pg_dump备份方法](http://rainbow702.iteye.com/blog/1318741)
* [PostgreSQL官网：pg_dump](http://www.postgresql.org/docs/9.2/static/app-pgdump.html)