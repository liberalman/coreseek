
#### 首先在本机上编译coreseek
环境：centos 3.10.0-327.36.3.el7.x86_64
gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) 
版本：coreseek-4.1-beta

下载，解压，进入coreseek-4.1-beta

```
./configure --prefix=/usr/local/coreseek  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
make
make install
```
#### 制作docker镜像
上一步生成的编译结果在 /usr/local/coreseek ，于是我进入到/usr/local/下

新建Dockerfile文件，内容参考本项目的Dockerfile文件。

写好Dockerfile之后，开始制作镜像，镜像名称liberalman/coreseek
```
docker build -t liberalman/coreseek .
```


要以终端的形式登录liberalman/coreseek镜像，执行完退出删除镜像的，用下面的命令
```
docker run -v /var/coreseek/:/usr/local/coreseek/var/ -v /var/coreseek/log/:/usr/local/coreseek/var/log/ -e "SPHINX_MODE=indexing" --rm -it liberalman/coreseek /bin/sh
```

如果只做全量或增量索引，而不启动coreseek进程，执行完之后就退出删除docker的，用下面的命令
```
docker run -v /var/coreseek/:/usr/local/coreseek/var/ -v /var/coreseek/log/:/usr/local/coreseek/var/log/ -e "SPHINX_MODE=indexing" --rm liberalman/coreseek
```


#### coreseek命令参考
##### 做全量索引
indexer --config /usr/local/coreseek/etc/sphinx.conf --all --rotate


