# ckan安装
## 简介
ckan是世界领先的开放数据管理平台，集数据发布、数据共享、数据搜索和数据使用为一体，并且提供了强大而完善的RPC APIs供用户调用。ckan的主要使用对象是国家和地区政府、公司企业、组织机构等数据发布源，为数据开放和数据访问提供了一种便捷可行的实现方案。

已经在使用ckan管理政府数据的网站有：

1. [英国政府数据网站](http://data.gov.uk)
2. [美国政府数据网站](http://data.gov)
3. [欧盟数据网站](http://publicdata.eu)
4. [巴西政府数据网站](http://dados.gov.br)

当然还有很多其他网站，这里就不一一列举了。

ckan的代码可以在github上下载，正在开发的最新版本为2.3，最新的稳定版本为2.2: [https://github.com/ckan/ckan](https://github.com/ckan/ckan)

ckan的参考文档中，[2.3最新版本](http://http://docs.ckan.org/en/latest/)内容比较完整，而且文档结构紧凑，但是存在一些bugs。[2.2版本](http://http://docs.ckan.org/en/ckan-2.2/)内容则相对稳定，所以按照2.3版本参考文档配置出错的时候，不妨回过头来查看2.2版本参考文档。

PS：本文中给出的参考文档链接都来源于2.2版本，个人觉得内容比较可靠。

## 安装
ckan的常用安装方法有2种：

1. [Installing CKAN from package](http://http://docs.ckan.org/en/ckan-2.2/install-from-package.html)
2. [Installing CKAN from source](http://http://docs.ckan.org/en/ckan-2.2/install-from-source.html)

第一种方法是最简单的安装方法，package中已经为你完成了安装的大部分配置内容，但是仅可用于生产环境；如果你希望用ckan进行开发，并根据自己的需求修改ckan的功能，那么第二种方法，即source是更好的选择。

如果选择install from source，还需要自行[部署web服务器](http://http://docs.ckan.org/en/ckan-2.2/deployment.html)，之后才可以在浏览器中访问你的ckan网站。

PS：第二种方法中创建ckan安装的python虚环境这一步，请按以下命令执行：

	sudo mkdir -p /usr/lib/ckan/default
	sudo chown `whoami` /usr/lib/ckan/default
	virtualenv /usr/lib/ckan/default
	. /usr/lib/ckan/default/bin/activate

PS的PS：如果你选择install from source，不要直接从ckan官方github repo安装，首先应当在自己的github中fork一分repo。这使得你可以在本地编辑代码，通过push到自己的github repo，然后在服务器上pull来实现代码托管。

可以看到，在两种安装方法中，相同的核心部分包括安装需要的环境包、配置数据库postgres和搜索引擎solr。

按照以上教程完成ckan的安装之后，就可以在浏览器中访问你的ckan网站了，当然仍只是一个很基础的demo。