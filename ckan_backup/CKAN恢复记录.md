# 安装CKAN
添加一个用户ckan，用来装ckan

给ckan用户sudo权限
visudo
添加一行
ckan ALL=(ALL) ALL
ctrl + o
ctrl + x

安装依赖
sudo apt-get update
sudo apt-get install python-dev postgresql libpq-dev python-pip python-virtualenv git-core solr-jetty openjdk-6-jdk

安装CKAN虚环境
mkdir -p ~/ckan/lib
sudo ln -s ~/ckan/lib /usr/lib/ckan
mkdir -p ~/ckan/etc
sudo ln -s ~/ckan/etc /etc/ckan
sudo mkdir -p /usr/lib/ckan/default
sudo chown `whoami` /usr/lib/ckan/default
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

安装CKAN 2.2.4版本
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.2.4#egg=ckan'
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt
deactivate
. /usr/lib/ckan/default/bin/activate

配置PostgreSQL，新增用户ckan_default
sudo -u postgres createuser -S -D -R -P ckan_default
新增数据库ckan_default
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8

添加CKAN配置文件
sudo mkdir -p /etc/ckan/default
sudo chown -R `whoami` /etc/ckan/
cd /usr/lib/ckan/default/src/ckan
paster make-config ckan /etc/ckan/default/development.ini

编辑配置文件
sqlalchemy.url = postgresql://ckan_default:ckan_default@<remotehost>/ckan_default?sslmode=disable

配置Solr
sudo vim /etc/default/jetty
编辑以下内容
NO_START=0            # (line 4)
JETTY_HOST=127.0.0.1  # (line 15)
JETTY_PORT=8983       # (line 18)
运行Jetty
sudo service jetty start
用CKAN所带搜索配置替换Jetty默认配置
sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
重启Jetty
sudo service jetty restart
在CKAN配置文件中修改以下内容
solr_url=http://127.0.0.1:8983/solr

新增数据库表
cd /usr/lib/ckan/default/src/ckan
paster db init -c /etc/ckan/default/development.ini

## 配置Datastore
在CKAN配置文件插件中添加datastore
ckan.plugins = datastore
新建用户datastore_default
sudo -u postgres createuser -S -D -R -P -l datastore_default
新建数据库datastore_default
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
在CKAN配置文件中配置url
ckan.datastore.write_url = postgresql://ckan_default:ckan_default@localhost/datastore_default
ckan.datastore.read_url = postgresql://datastore_default:datastore_default@localhost/datastore_default
设置用户datastore_default写权限
paster --plugin=ckan datastore set-permissions postgres -c /etc/ckan/default/development.ini

链接who.ini
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

## 部署apache和nginx
生成production.ini
cp /etc/ckan/default/development.ini /etc/ckan/default/production.ini
安装apache、modwsgi、modrpaf
sudo apt-get install apache2 libapache2-mod-wsgi libapache2-mod-rpaf
安装nginx
sudo apt-get install nginx
安装邮件服务器
sudo apt-get install postfix
新建apache.wsgi
vim /etc/ckan/default/apache.wsgi
添加以下内容
import os
activate_this = os.path.join('/usr/lib/ckan/default/bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))
from paste.deploy import loadapp
config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'production.ini')
from paste.script.util.logging_config import fileConfig
fileConfig(config_filepath)
application = loadapp('config:%s' % config_filepath)
新建apache配置文件
sudo vim /etc/apache2/sites-available/ckan_default.conf
添加以下内容
<VirtualHost *:80>
    ServerName default.ckanhosted.com
    ServerAlias www.default.ckanhosted.com
    WSGIScriptAlias / /etc/ckan/default/apache.wsgi

    # Pass authorization info on (needed for rest api).
    WSGIPassAuthorization On

    # Deploy as a daemon (avoids conflicts between CKAN instances).
    WSGIDaemonProcess ckan_default display-name=ckan_default processes=2 threads=15

    WSGIProcessGroup ckan_default

    ErrorLog /var/log/apache2/ckan_default.error.log
    CustomLog /var/log/apache2/ckan_default.custom.log combined

    <IfModule mod_rpaf.c>
        RPAFenable On
        RPAFsethostname On
        RPAFproxy_ips 127.0.0.1
    </IfModule>

    <Directory />
        Require all granted
    </Directory>
</VirtualHost>
新建nginx配置文件
sudo vim /etc/nginx/sites-available/ckan_default
添加以下内容
proxy_cache_path /tmp/nginx_cache levels=1:2 keys_zone=cache:30m max_size=250m;
proxy_temp_path /tmp/nginx_proxy 1 2;

server {
    client_max_body_size 100M;
    location / {
        proxy_pass http://127.0.0.1:80/;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_cache cache;
        proxy_cache_bypass $cookie_auth_tkt;
        proxy_no_cache $cookie_auth_tkt;
        proxy_cache_valid 30m;
        proxy_cache_key $host$scheme$proxy_host$request_uri;
        # In emergency comment out line to force caching
        # proxy_ignore_headers X-Accel-Expires Expires Cache-Control;
    }
}
启用以上更改
sudo a2ensite ckan_default
sudo a2dissite 000-default
sudo rm -vi /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/ckan_default /etc/nginx/sites-enabled/ckan_default
sudo service apache2 reload
sudo service nginx reload

## 配置Datapusher
安装依赖
sudo apt-get install python-dev python-virtualenv build-essential libxslt1-dev libxml2-dev git
安装Datapusher
cd ~
git clone https://github.com/ckan/datapusher
cd datapusher
pip install -r requirements.txt
pip install -e .
启动Datapusher
python datapusher/main.py deployment/datapusher_settings.py
更改CKAN配置文件
ckan.datapusher.url = http://0.0.0.0:8800/
ckan.site_url = http://your.ckan.instance.com
ckan.plugins = <other plugins> datapusher

## 配置Filestore
新建Filestore文件夹
sudo mkdir -p /var/lib/ckan/default
更改CKAN配置文件
ckan.storage_path = /var/lib/ckan/default
更改该文件夹权限
sudo chown www-data /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default
重启apache
sudo service apache2 restart

## 安装主题插件
cd /usr/lib/ckan/default/src/
git clone https://github.com/Honlan/ckanext-mytheme
cd ckanext-mytheme/
python setup.py develop

## 安装ckanext-spatial
安装postgis
sudo apt-get install postgresql-9.3-postgis-2.1
安装其他依赖
sudo apt-get install python-dev libxml2-dev libxslt1-dev libgeos-c1
安装插件
cd /usr/lib/ckan/default/src/
pip install -e "git+https://github.com/okfn/ckanext-spatial.git#egg=ckanext-spatial"
cd ckanext-spatial/
pip install -r pip-requirements.txt
修改CKAN配置文件
ckan.plugins = spatial_metadata spatial_query
ckan.spatial.srid = 4326

## 恢复备份数据
sudo service jetty stop
sudo service apache2 stop
dropdb -U postgres ckan_default
dropdb -U postgres datastore_default
createdb -U postgres -O ckan_default ckan_default -E utf-8
createdb -U postgres -O ckan_default datastore_default -E utf-8
sudo -u postgres psql -d ckan_default -f /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql
sudo -u postgres psql -d ckan_default -f /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql
sudo -u postgres psql -d ckan_default -c 'ALTER VIEW geometry_columns OWNER TO ckan_default;'
sudo -u postgres psql -d ckan_default -c 'ALTER TABLE spatial_ref_sys OWNER TO ckan_default;'
. /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src/ckan
paster --plugin=ckan datastore set-permissions postgres -c /etc/ckan/default/production.ini
cd ~
psql -U postgres ckan_default < /home/ckan/"$tday"/ckan_default.sql
psql -U postgres datastore_default < /home/ckan/"$tday"/datastore_default.sql
sudo bash
cd /var/lib/ckan
rm -rf default/
tar -xzvf /home/ckan/"$tday"/default.tar.gz default/
chown www-data /var/lib/ckan/default
chmod u+rwx /var/lib/ckan/default
cd /var/lib/solr
rm -rf data/
tar -xzvf /home/ckan/"$tday"/data.tar.gz data/
service jetty start
service apache2 start
