FROM centos
MAINTAINER lejianwen <84855512@qq.com>
RUN yum -y install epel-release make gcc gcc++
ENV downurl http://download.redis.io/releases/redis-5.0.5.tar.gz
RUN mkdir /data/src/redis -p && cd /data/src \
    && curl -L $downurl -o redis.tar.gz \
    && tar -zxf redis.tar.gz -C ./redis --strip-components 1 \
    && cd redis && make && make install && rm /data/src -rf && yum clean all
EXPOSE 6379
CMD ["redis-server"]