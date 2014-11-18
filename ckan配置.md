# ckan配置
按照上一篇文章安装完ckan之后，你便可以在浏览器中访问自己的ckan网站了。这次我们将要讨论如何配置ckan的一些核心功能。

## FileStore and File Uploads
FileStore提供了文件上传的功能。在已有数据集中添加资源时，需要指定资源来源，默认只有外部链接方式，而FileStore则提供了本地上传功能。

[FileStore配置](http://docs.ckan.org/en/ckan-2.2/filestore.html)包括以下几步：

1. 新建FileStore文件存放路径； 
2. 修改配置文件，在[app:main]中添加以上存放路径；
3. 修改存放路径文件夹的归属和权限；
4. 重启web服务器。

FileStore拥有对应的[API](http://docs.ckan.org/en/ckan-2.2/filestore.html#filestore-api)，即：

1. resource_create();
2. resource_update();

前者用来新建一个resource，来源可以是本地文件或者外部链接；后者用来更新资源，包括更新资源描述信息、将上传文件改为外部链接、将外部链接改为上传文件。

## Datastore Extension
DataStore的功能是对于某些格式化文件，如json、csv、xls等，将其分解为可预览的单元，这样用户不用下载便可以预览资源内容。

[DataStore配置](http://docs.ckan.org/en/ckan-2.2/datastore.html)包括以下几个内容：

1. 在配置文件插件项中加入Datastore；
2. 配置数据库；
3. 设置访问权限；
4. 配置[Datapusher](http://docs.ckan.org/projects/datapusher/en/latest/)。

其中Datapusher用来将通过FileStore上传的文件自动添加到DataStore中去。

DataStore也有自己对应的[API](http://docs.ckan.org/en/ckan-2.2/datastore.html#the-datastore-api)，包括：

1. datastore_create()；
2. datastore_upsert()；
3. datastore_delete()；
4. datastore_search()；
5. datastore_search_sql()；
6. datastore_make_private()；
7. datastore_make_public()。

函数具体说明和使用方法请参考官方文档。


## Data Viewer

[Data Viewer](http://docs.ckan.org/en/ckan-2.2/data-viewer.html)提供了大部分格式文件的预览功能，主要包括以下几类：

1. 图片和文本型，一般可以在内联窗口中直接加载，包裹ckan.preview.direct和ckan.preview.loadable；
2. csv和xls等类型，使用recline_preview预览；
3. json和xml等类型，使用text_preview预览；
4. pdf类文件，使用pdf_preview预览；
5. 访问远程链接文件，使用resource_proxy实现。

## Email Notifications
[邮件通知](http://docs.ckan.org/en/ckan-2.2/email-notifications.html)使得在用户动态流有新通知时，发送邮件通知用户。

需要设置一个cron定时器来定时检测是否需要发送邮件通知，同时更改配置文件中的相关选项。

## Page View Tracking
[Page View Tracking](http://docs.ckan.org/en/ckan-2.2/tracking.html)功能使得ckan记录下每个数据集的访问次数，从而提供诸如按热门程度搜索数据集等功能。

## Stats Extension 
[Stats插件](http://docs.ckan.org/en/ckan-2.2/stats.html)用来计算ckan网站数据集、组织、群组和用户的个数等很多有用的统计数据，配置文件中默认开启此功能，在ckan网站链接后添加/stats即可访问。
