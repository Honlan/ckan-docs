# PostgreSQL学习记录

既然打算系统地学习一下PostgreSQL，那么有必要了解PostgreSQL的一些基本内容。

## 体系概念

PostgreSQL使用一种客户端/服务器的模式，一次PostgreSQL会话由下列相关进程（程序）组成：

1. 一个服务器进程，它管理数据库文件，接受来自客户端应用与数据库的联接，并且代表客户端在数据库上执行操作。 数据库服务器程序叫做 postmaster；
2. 需要执行数据库操作的用户客户端（前端）应用。

和典型的客户端/服务器应用（C/S应用）一样，客户端和服务器可以部署在不同的主机上，通过TCP/IP网络联接通讯。

PostgreSQL服务器可以处理来自客户端的多个并发请求，它为每个请求启动（fork）一个新的进程。 从这个时候开始，客户端和新服务器进程就不再经过最初的postmaster进程的干涉进行通讯。

PostgreSQL 是一种关系型数据库管理系统（RDBMS）。每个表都是一个命名的行的集合，每一行由一组相同的命名字段组成，而且每一字段都特定的类型。

表组成数据库，一个由某个PostgreSQL服务器管理的数据库集合组成一个数据库集群。

## 基本操作

PostgreSQL命令有两种形式：

1. 进入PostgreSQL控制台后操作，形如：$sudo -u postgres psql
2. 直接使用shell命令行，形如：$sudo -u postgres psql -l

进入shell命令行后，既可以使用"\command"形式的命令，也可以使
用"command;"形式的命令，这对新手来说是很容易混淆的。

基本操作包括对数据库、表、字段、记录的CURD操作，和其他数据库类似。

更多示例请参考[阮一峰博客PostgreSQL基本操作](http://www.ruanyifeng.com/blog/2013/12/getting_started_with_postgresql.html)，其中介绍了Postgre
SQL的安装、添加用户和数据库、登录数据库、控制台命令和数据库操作。

## 其他命令

SELECT version(); 查看当前PostgreSQL版本

SELECT current_date; 查看当前时间

SELECT 2+2; 进行基本运算   

COPY tableName FROM '/home/user/file.txt'; 导入数据

## 参考资料

* [PostgreSQL8.1手册](http://www.php100.com/manual/PostgreSQL8/)
* [PostgreSQL中常用的SQL命令](http://www.php100.com/manual/PostgreSQL8/sql.html)
* [阮一峰博客PostgreSQL基本操作](http://www.ruanyifeng.com/blog/2013/12/getting_started_with_postgresql.html)
* [PostgreSQL官网手册](http://www.postgresql.org/docs/9.2/static/)









