
#### 首先在本机上编译coreseek

| 软件 | 版本 |
| --- | --- |
| centos | 3.10.0-327.36.3.el7.x86_64 |
| gcc | version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC)  |
| coreseek | coreseek-4.1-beta |

安装必须的依赖，不安装这些编译无法通过
```
yum install make gcc g++ gcc-c++ libtool autoconf automake imake mysql-devel libxml2-devel expat-devel
```
如果是ubuntu等使用apt-get命令的
```
apt-get install make gcc g++ automake libtool mysql-client libmysqlclient-dev libxml2-dev libexpat1-dev
```


下载coreseek-4.1-beta.tar.gz，解压，进入coreseek-4.1-beta

安装mmseg分词，这个是中文分词的插件

```
cd coreseek-4.1-beta/mmseg-3.2.14/
./bootstrap
./configure --prefix=/usr/local/mmseg3    #配置安装位置
make && make install
#编译、安装 mmseg-3.2.14
```


```
cd coreseek-4.1-beta/csft-4.1
sh buildconf.sh
./configure --prefix=/usr/local/coreseek  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
make
make install
```

> 注意:执行上一步的 sh buildconf.sh 可能会遇到问题，没生成configure，要
```
csft-4.1/buildconf.sh
查找
&& aclocal
后加上
&& automake --add-missing
csft-4.1/configure.ac
查找
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
改为
AM_INIT_AUTOMAKE([-Wall foreign])
查找
AC_PROG_RANLIB
后面加上
AM_PROG_AR
csft-4.1/src/sphinxexpr.cpp
替换所有
T val = ExprEval ( this->m_pArg, tMatch );
为
T val = this->ExprEval ( this->m_pArg, tMatch );
```

这样就能生成configure了，有人说把automake版本降低为1.11，就可以了，没试。


#### 制作docker镜像
上一步生成的编译结果在 /usr/local/coreseek ，于是我进入到/usr/local/下

新建Dockerfile文件，内容参考本项目的Dockerfile文件。

写好Dockerfile之后，开始制作镜像，镜像名称liberalman/coreseek
```
docker build -t liberalman/coreseek .
```

```
mkdir /var/coreseek/
mkdir /var/coreseek/log
mkdir /var/coreseek/data
```


要以终端的形式登录liberalman/coreseek镜像，执行完退出删除镜像的，用下面的命令
```
docker run -v /var/coreseek/:/usr/local/coreseek/var/ -v /var/coreseek/log/:/usr/local/coreseek/var/log/ -e "SPHINX_MODE=indexing" --rm -it liberalman/coreseek /bin/sh
```

如果只做全量或增量索引，而不启动coreseek进程，执行完之后就退出删除docker的，用下面的命令
```
docker run -v /var/coreseek/:/usr/local/coreseek/var/ -v /var/coreseek/data/:/usr/local/coreseek/var/data/  -v /var/coreseek/log/:/usr/local/coreseek/var/log/ -v /usr/local/tmp/coreseek/sphinx-index.conf:/usr/local/coreseek/etc/sphinx.conf -e "SPHINX_MODE=indexing" --rm liberalman/coreseek
```
注意权限问题，必须-v将coreseek/var、coreseek/var/log、coreseek/var/data全都映射到宿主机上才能做索引成功，否则做的索引没权限写。报WARNING: indices NOT rotated.错误

#### coreseek命令参考
##### 做全量索引
indexer --config /usr/local/coreseek/etc/sphinx.conf --all --rotate


