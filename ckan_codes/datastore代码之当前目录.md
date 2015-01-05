#datastore代码之当前目录
代码位于ckan/ckanext/datastore/，一级目录包括：

- bin/
- logic/	
- tests/
- \__init__.py
- commands.py
- controller.py
- db.py
- plugin.py


##\__init__.py（0）
空文件，没啥好说的

##plugin.py（254）
该py代码中含有两个类：__DatastoreException__和__DatastorePlugin__，前者处理异常但除了pass之外没有任何代码，后者为该插件的核心类，包含以下函数：

- configure(self, config)，获取读写路径、是否只读、检查权限等配置项
- notify(self, entity, operation=None)，根据参数将数据集中的resource设为public或private
- _log_or_raise(self, message)，调试函数
- _check_urls_and_permissions(self)，检查读写路径和权限
- _is_read_only_database(self)，检查是否只读
- _same_ckan_and_datastore_db(self)，判断ckan和datastore数据集是否相同
- _get_db_from_url(self, url)，从读写路径url中获取数据库名
- _same_read_and_write_url(self)，判断读写路径是否相同
- _read_connection_has_correct_privileges(self)，检查读权限是否正确
- _create_alias_table(self)，创建alias表
- get_actions(self)，获取datastore常用操作函数（即API）
- get_auth_functions(self)，获取以上操作对应权限函数
- before_map(self, m)，返回dump格式的resource
- before_show(self, resource_dict)，将resource url修改为dump格式并确认对应datastore的状态

PS：以下划线开头的函数仅用于其他函数的调用中


##commands.py（74）
该py代码中只含有一个类：__SetupDatastoreCommand__，该类完成datastore的初始化工作如set-permission等，包含两个函数：

- \__init__(self, name)，只是super一下罢了
- command(self)，根据paster datastore命令所接参数执行set-permission操作或提供帮助文档

##controller.py（45）
该py代码中只含有一个类：__DatastoreController__，该类中只包含一个函数：

- dump(self, resource_id)：该函数调用datastore_search，读取datastore数据、逐条写入csv并导出

##db.py（1242）
该py代码中包含和PostgreSQL有关的数据库操作函数，定义了\_pg_types、\_type_names、\_engines、\_TIMEOUT、\_PG_ERR_CODE、\_DATE_FORMATS等常量，包含以下函数：

- _strip(input)，字符串裁剪
- _pluck(field, arr)，list值提取
- _get_list(input, strip=True)，字符串转换为list
- _is_valid_field_name(name)，判断名称是否合法
- _is_valid_table_name(name)，判断表名是否合法
- _validate_int(i, field_name, non_negative=False)，判断是否为整数
- _get_engine(data_dict)，获取数据库读写引擎
- _cache_types(context)，确定缓存类型
- _pg_version_is_at_least(connection, version)，判断PostgreSQL版本是否符合要求
- _is_valid_pg_type(context, type_name)，判断是否为合法PostgresSQL类型
- _get_type(context, oid)，获得类型
- _rename_json_field(data_dict)，将“json”类型更名为“nested”
- _unrename_json_field(data_dict)，将“nested”类型更名为“json”
- _rename_field(data_dict, term, replace)，重命名field name
- _guess_type(field)，猜测某个field的数据类型
- _get_fields(context, data_dict)，获得某些fields的值
- json_get_values(obj, current_list=None)，从json中获取值并返回列表
- check_fields(context, fields)，检查field names是否合法
- convert(data, type_name)，数据类型转换
- create_table(context, data_dict)，根据上传的文件生成表
- _get_aliases(context, data_dict)，获取resource的aliases
- _get_resources(context, alias)，获取alias对应的resource
- create_alias(context, data_dict)，新建alias
- create_indexes(context, data_dict)，新建index索引
- _drop_indexes(context, data_dict, unique=False)，删除index索引
- alter_table(context, data_dict)，修改表
- insert_data(context, data_dict)，插入数据
- upsert_data(context, data_dict)，update＋insert数据
- _get_unique_key(context, data_dict)，获取主键
- _validate_record(record, num, field_names)，检查某条记录是否合法
- _to_full_text(fields, record)，将记录转换成text
- _where(field_ids, data_dict)，返回where从句
- _textsearch_query(data_dict)，q全文本搜索
- _sort(context, data_dict, field_ids)，排序搜索结果
- _insert_links(data_dict, limit, offset)，添加翻页链接
- delete_data(context, data_dict)，删除数据
- search_data(context, data_dict)，搜索数据
- format_results(context, results, data_dict)，格式化搜索结果
- _is_single_statement(sql)，判断是否为单条sql
- create(context, data_dict)，上层create调用
- upsert(context, data_dict)，上层upsert调用
- delete(context, data_dict)，上层delete调用
- search(context, data_dict)，上层search调用
- search_sql(context, data_dict)，上层search_sql调用
- _get_read_only_user(data_dict)，获得只读用户
- _change_privilege(context, data_dict, what)，修改公开性
- make_private(context, data_dict)，将resource设为private
- make_public(context, data_dict)，将resource设为public