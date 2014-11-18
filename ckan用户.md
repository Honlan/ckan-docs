# ckan用户
ckan中的用户分为三类：普通用户、组织/群组管理员、系统管理员。

## 普通用户
顾名思义，普通用户就是ckan中注册的一般用户。

普通用户的权限包括：新建数据集、新建组织、新建群组等。对于新建的数据集，普通用户可以执行添加资源、删除资源、修改基本信息、删除数据集等操作。

## 组织/群组管理员
普通用户新建组织/群组后，便成为了该组织/群组的管理员。组织/群组的管理员可以邀请其他用户加入，还可以向组织/群组中添加数据集。其他用户加入该组织/群组之后，也可以添加自己的数据集。

因此相对于普通用户，组织/群组管理员还具备管理组织/群组中的用户和数据集的权限。

## 系统管理员
系统管理是相对于整个ckan网站而言的，系统管理员具备普通用户和所有组织/群组管理员的权限。除此之外，系统管理员还可以更改网站配置、管理所有数据集、用户、组织和群组。因此对于一个ckan网站而言，系统管理员具有最高权限，同时一个ckan网站可以有多个系统管理员。

## 参考文档
[Ckan User Guide](http://docs.ckan.org/en/ckan-2.2/user-guide.html)

[Ckan Sysadmin Guide](http://http://docs.ckan.org/en/ckan-2.2/sysadmin-guide.html)

[How to Create A Sysadmin](http://docs.ckan.org/en/ckan-2.2/sysadmin-guide.html#creating-a-sysadmin-account) 