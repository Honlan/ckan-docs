#datastore代码之logic
代码位于ckan/ckanext/datastore/logic/，包括以下文件：

- \__init__.py
- action.py
- auth.py
- schema.py

logic文件夹中的代码一般起到函数调用的作用，大部分都调用了db.py中处理数据库的底层函数

##\__init__.py（0）
空文件，没啥好说的

##action.py（472）
该py代码中集成了datastore插件的所有动作（action），包括以下函数：

- datastore_create(context, data_dict)，新建datastore
- datastore_upsert(context, data_dict)，向datastore中upsert一条记录
- datastore_delete(context, data_dict)，删除数据记录或者整个datastore
- datastore_search(context, data_dict)，以参数形式搜索datastore
- datastore_search_sql(context, data_dict)，以sql形式搜索datastore
- datastore_make_private(context, data_dict)，使datastore变为private
- datastore_make_public(context, data_dict)，使datastore变为public
- _resource_exists(context, data_dict)，判断resource是否存在
- _check_read_only(context, data_dict)，检查是否只读，如果是且正在进行写操作则抛出异常

##auth.py（45）
该py代码中包含对datastore常用操作的认证函数，判断操作是否具有合法权限。通过ckan.plugins.toolkit.check_access(privilege, context, data_dict)实现函数datastore_auth(context, data_dict, privilege='resource_update')，并调用此函数完成以下认证：

- datastore_create(context, data_dict)
- datastore_upsert(context, data_dict)
- datastore_delete(context, data_dict)
- datastore_search(context, data_dict)
- datastore_search_sql(context, data_dict)
- datastore_change_permissions(context, data_dict)

##schema.py（126）
该py代码定义了datastore常用操作的参数规范（schema），包含以下函数：

- rename(old, new)，将某个field重命名
- list_of_strings_or_lists(key, data, errors, context)，数据类型为字符串列表或者列表
- list_of_strings_or_string(key, data, errors, context)，数据类型为字符串列表或者字符串
- json_validator(value, context)，json校验器
- datastore_create_schema()
- datastore_upsert_schema()
- datastore_delete_schema()
- datastore_search_schema()