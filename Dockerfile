FROM alpine:latest
MAINTAINER liberalman liberalman@github.com

#RUN apk --update --no-cache add runit
RUN apk --update add runit

COPY coreseek /usr/local/coreseek
WORKDIR /usr/local/coreseek
ENV PATH=${PATH}:/usr/local/coreseek/bin

ENV SPHINX_CONF=/usr/local/coreseek/etc/sphinx.conf
COPY sphinx.conf ${SPHINX_CONF}
ADD sphinx.service /etc/service/sphinx/run
RUN chmod +x /etc/service/sphinx/run

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

RUN ln -sf /dev/stdout /usr/local/coreseek/var/log/searchd.log \
    && ln -sf /dev/stdout /usr/local/coreseek/var/log/query.log

EXPOSE 9312 9306
CMD ["runsvdir", "/etc/service"]

