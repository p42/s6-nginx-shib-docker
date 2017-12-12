#!/bin/bash

set -x

NGINX_VERSION=${1:-"1.11.6"}
MORE_HEADERS_VERSION=${2:-"0.32"}
ECHO_VERSION=${3:-"0.60"}
NGINX_SHIB_VERSION=${4:-"2.0.0"}
LUA_VERSION=${5:-"0.10.7"}

pushd /tmp

    # download binaries
    # TODO: verify SHA/MD5 hashes
    curl -L "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" | tar xz
    curl -L "https://github.com/openresty/headers-more-nginx-module/archive/v${MORE_HEADERS_VERSION}.tar.gz" | tar xz
    curl -L "https://github.com/openresty/echo-nginx-module/archive/v${ECHO_VERSION}.tar.gz" | tar xz
    curl -L "https://github.com/openresty/lua-nginx-module/archive/v${LUA_VERSION}.tar.gz" | tar xz
    curl -L "https://github.com/nginx-shib/nginx-http-shibboleth/archive/v${NGINX_SHIB_VERSION}.tar.gz" | tar xz

    pushd "nginx-${NGINX_VERSION}"

        # configure and build nginx
        ./configure \
            --prefix=/etc/nginx \
            --sbin-path=/usr/sbin/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --user=_shibd \
            --group=_shibd \
            --with-debug \
            --with-http_auth_request_module \
            --with-http_realip_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-pcre \
            --add-module="../echo-nginx-module-${ECHO_VERSION}" \
            --add-module="../headers-more-nginx-module-${MORE_HEADERS_VERSION}" \
            --add-module="../lua-nginx-module-${LUA_VERSION}" \
            --add-module="../nginx-http-shibboleth-${NGINX_SHIB_VERSION}"

        make -j2 && make install

    popd

    # clean up
    rm -Rf "nginx-${NGINX_VERSION}" \
           "echo-nginx-module-${ECHO_VERSION}" \
           "headers-more-nginx-module-${MORE_HEADERS_VERSION}" \
           "lua-nginx-module-${LUA_VERSION}" \
           "nginx-http-shibboleth-${NGINX_SHIB_VERSION}"

popd
