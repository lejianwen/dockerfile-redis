FROM centos as base
MAINTAINER lejianwen <84855512@qq.com>
RUN yum -y install epel-release make gcc gcc++
ENV downurl http://download.redis.io/releases/redis-5.0.5.tar.gz
RUN mkdir /data/src/redis -p && cd /data/src \
    && curl -L $downurl -o redis.tar.gz \
    && tar -zxf redis.tar.gz -C ./redis --strip-components 1 \
    && cd redis && make && make install && rm /data/src -rf && yum clean all

FROM base as builder
MAINTAINER lejianwen <84855512@qq.com>
WORKDIR /rootfs
RUN mkdir -p lib64 usr/bin && cp /lib64/lib{rt,m,dl,pthread,c}.so.* lib64/ && cp /lib64/ld-linux-x86-64.so.2 lib64/ \
    && cp /usr/local/bin/* ./usr/bin \
    && rm -f ./usr/bin/redis-sentinel \
    && strip ./usr/bin/redis-benchmark \
    && strip ./usr/bin/redis-check-aof \
    && strip ./usr/bin/redis-check-rdb \
    && strip ./usr/bin/redis-cli \
    && strip ./usr/bin/redis-server


FROM busybox
MAINTAINER lejianwen <84855512@qq.com>

RUN echo redis:x:1002:1002:redis:/:/bin/sh >> etc/passwd \
        && echo redis:x:1002: >> etc/group
RUN mkdir /lib \
    && ln -s /lib /lib64 \
    && mkdir /data && touch /etc/resolv.conf

COPY --from=builder /etc/nsswitch.conf /etc/nsswitch.conf
COPY --from=builder /etc/pki /etc/pki
COPY --from=builder /rootfs/lib64/* /lib64/
COPY --from=builder /rootfs/usr/bin/* /usr/bin/
EXPOSE 6379
CMD ["redis-server"]