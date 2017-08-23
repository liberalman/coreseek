
centos 3.10.0-327.36.3.el7.x86_64

gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) 

docker build -t liberalman/coreseek .

docker run -v /var/coreseek/:/usr/local/coreseek/var/ -v /var/coreseek/log/:/usr/local/coreseek/var/log/ -e "SPHINX_MODE=indexing" --rm -it liberalman/coreseek /bin/sh



docker run -v /var/coreseek/:/usr/local/coreseek/var/ -v /var/coreseek/log/:/usr/local/coreseek/var/log/ -e "SPHINX_MODE=indexing" --rm liberalman/coreseek

indexer --config /etc/sphinx/sphinx.conf --all --rotate


