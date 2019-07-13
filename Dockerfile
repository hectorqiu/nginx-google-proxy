FROM ubuntu:16.04
MAINTAINER Hector Qiu <hectorqiuiscool@gmail.com>

# set env vars
ENV container docker
ENV DEBIAN_FRONTEND noninteractive

ENV NGINX_VERSION 1.10.3
ENV PCRE_VERSION 8.40
ENV OPENSSL_VERSION 1.1.0e
ENV ZLIB_VERSION 1.2.11

# 如果是国内机器，需要替换 sources
# ADD conf/cn_sources.list /etc/apt/sources.list

RUN apt-get update

# install base tools
RUN apt-get install -y -qq git wget build-essential zlib1g-dev libpcre3-dev git gcc g++ make

# download src


RUN mkdir -p /usr/src \
    && cd /usr/src \
    && wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    && wget "https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz" \
    && wget "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" \
    && wget "https://zlib.net/zlib-$ZLIB_VERSION.tar.gz" \
    && git clone https://github.com/cuber/ngx_http_google_filter_module \
    && git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module \
    && tar xzf nginx-$NGINX_VERSION.tar.gz \
    && tar xzf pcre-$PCRE_VERSION.tar.gz \
    && tar xzf openssl-$OPENSSL_VERSION.tar.gz \
    && tar xzf zlib-$ZLIB_VERSION.tar.gz

RUN cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure --prefix=/etc/nginx  \
        --sbin-path=/usr/sbin/nginx  \
        --conf-path=/etc/nginx/nginx.conf  \
        --error-log-path=/var/log/nginx/error.log  \
        --http-log-path=/var/log/nginx/access.log  \
        --pid-path=/var/run/nginx.pid  \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp  \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp  \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp  \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp  \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp  \
        --user=nginx  \
        --group=nginx  \
        --with-http_ssl_module  \
        --with-http_realip_module  \
        --with-http_addition_module  \
        --with-http_sub_module  \
        --with-http_dav_module  \
        --with-http_flv_module  \
        --with-http_mp4_module \
        --with-http_gunzip_module  \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module  \
        --with-http_stub_status_module  \
        --with-http_auth_request_module  \
        --with-threads  \
        --with-stream  \
        --with-stream_ssl_module  \
        --with-http_slice_module  \
        --with-mail  \
        --with-mail_ssl_module  \
        --with-file-aio  \
        --with-http_v2_module  \
        --with-ipv6  \
        --with-pcre=../pcre-$PCRE_VERSION \
        --with-openssl=../openssl-$OPENSSL_VERSION \
        --with-zlib=../zlib-$ZLIB_VERSION  \
        --add-module=../ngx_http_google_filter_module  \
        --add-module=../ngx_http_substitutions_filter_module && \

    make install \
    && useradd --no-create-home nginx \
    && mkdir -p /var/cache/nginx \
    && mkdir -p /etc/nginx/sites-enabled \
    && mkdir -p /etc/nginx/streams-enabled

ADD conf/nginx/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx/sites-enabled/* /etc/nginx/sites-enabled/
#ADD conf/nginx/streams-enabled/* /etc/nginx/streams-enabled/

EXPOSE 80
EXPOSE 443

CMD nginx && tail -F /var/log/nginx/access.log




