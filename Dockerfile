FROM redis:3.2

MAINTAINER Johan Andersson <Grokzen@gmail.com>

# Some Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g  /etc/apt/sources.list && apt-get update

# Install system dependencies
RUN apt-get install --no-install-recommends -y \
    net-tools supervisor ruby rubygems locales gettext-base wget && \
    apt-get clean -y

# # Ensure UTF-8 lang and locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Necessary for gem installs due to SHA1 being weak and old cert being revoked
ENV SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN gem install redis -v 3.3.3

RUN apt-get install -y gcc make g++ build-essential libc6-dev tcl git supervisor ruby

ARG redis_version=4.0.11

RUN wget -qO redis.tar.gz https://github.com/antirez/redis/archive/${redis_version}.tar.gz \
    && tar xfz redis.tar.gz -C / \
    && mv /redis-${redis_version} /redis

RUN (cd /redis && make)

RUN mkdir /redis-conf
RUN mkdir /redis-data

COPY ./docker-data/redis-cluster.tmpl /redis-conf/redis-cluster.tmpl
COPY ./docker-data/redis.tmpl /redis-conf/redis.tmpl

# Add startup script
COPY ./docker-data/docker-entrypoint.sh /docker-entrypoint.sh

# Add script that generates supervisor conf file based on environment variables
COPY ./docker-data/generate-supervisor-conf.sh /generate-supervisor-conf.sh

RUN chmod 755 /docker-entrypoint.sh

EXPOSE 7000 7001 7002 7003 7004 7005 7006 7007

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]
