#datastore代码之bin
代码位于ckan/ckanext/datastore/bin/，包括以下文件：

- \__init__.py
- datastore_setup.py
- set_permissions.sql

既然位于bin文件夹中，自然是供其他代码调用


##\__init__.py（0）
空文件，没啥好说的

##datastore_setup.py（80）
该py代码完成基本的初始化工作，包括以下三个函数：

- \_run_cmd(command_line, inputstring='')，执行命令
- \_run_sql(sql, as_sql_user, database='postgres')，执行sql
- set_permissions(pguser, ckandb, datastoredb, ckanuser, writeuser, readonlyuser)，读取set_permissions.sql并执行，以完成数据库读写权限配置

##set_permissions.sql（55）
该sql文件包含关于数据库读写权限配置的sql操作：

- 主数据库，maindb
- datastore数据库，datastoredb
- ckan用户，ckanuser
- 写权限用户，writeuser
- 读权限用户，readonlyuser
- 相关GRANT和REVOKE操作

