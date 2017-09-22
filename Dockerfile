FROM alpine:latest
MAINTAINER liberalman liberalman@github.com

ENV SPHINX_DIR=/usr/local/coreseek
ENV PATH=${PATH}:${SPHINX_DIR}/bin:/usr/local/mmseg/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/mmseg/lib
ENV SPHINX_CONF=${SPHINX_DIR}/etc/sphinx.conf
WORKDIR ${SPHINX_DIR}

COPY add_cron /root/
COPY coreseek /usr/local/coreseek
COPY mmseg /usr/local/mmseg
COPY sphinx.conf ${SPHINX_CONF}
COPY entrypoint.sh /sbin/entrypoint.sh
COPY build_index.sh /sbin/build_index.sh

COPY libmysqlclient.so.18.0.0 /lib64/libmysqlclient.so.18
COPY libpthread.so.0 /lib64/libpthread.so.0
COPY libz.so.1 /lib64/libz.so.1
COPY libssl.so.10 /lib64/libssl.so.10
COPY libcrypto.so.10 /lib64/libcrypto.so.10
COPY libdl.so.2 /lib64/libdl.so.2
COPY libm.so.6 /lib64/libm.so.6
COPY libexpat.so.1 /lib64/libexpat.so.1
COPY librt.so.1 /lib64/librt.so.1
COPY libstdc++.so.6 /lib64/libstdc++.so.6
COPY libgcc_s.so.1 /lib64/libgcc_s.so.1
COPY libc.so.6 /lib64/libc.so.6
COPY ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY libgssapi_krb5.so.2 /lib64/libgssapi_krb5.so.2
COPY libkrb5.so.3 /lib64/libkrb5.so.3
COPY libcom_err.so.2 /lib64/libcom_err.so.2
COPY libk5crypto.so.3 /lib64/libk5crypto.so.3
COPY libkrb5support.so.0 /lib64/libkrb5support.so.0
COPY libkeyutils.so.1 /lib64/libkeyutils.so.1
COPY libresolv.so.2 /lib64/libresolv.so.2
COPY libselinux.so.1 /lib64/libselinux.so.1
COPY libpcre.so.1 /lib64/libpcre.so.1


RUN chmod 755 /sbin/entrypoint.sh \
    && chmod 755 /sbin/build_index.sh \
    && ln -sf /dev/stdout /usr/local/coreseek/var/log/searchd.log \
    && ln -sf /dev/stdout /usr/local/coreseek/var/log/query.log
RUN cat /root/add_cron >> /var/spool/cron/crontabs/root

EXPOSE 9312 9306
ENTRYPOINT ["/sbin/entrypoint.sh"]
