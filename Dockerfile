#Install and configure [] 

FROM project42/s6-debian:9
MAINTAINER Brandon Cone bcone@esu10.org

ENV NGINX_VERSION 1.12.2
RUN apt-get update
RUN apt-get install -y opensaml2-schemas \
      xmltooling-schemas \
      libshibsp7 \
      libshibsp-plugins \
      shibboleth-sp2-common \
      shibboleth-sp2-utils \
      procps \
      curl \
      git \
      build-essential \
      libpcre3 \
      libpcre3-dev \
      libpcrecpp0v5 \
      libssl-dev \
      zlib1g-dev \
      lua5.1 \
      liblua5.1-0-dev \
      lua-socket \
      libxslt1-dev \
      libgd-dev \
      libgeoip-dev \
      fcgiwrap \
      vim \
    && ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/lib/liblua.so \
    && rm -rf /var/lib/apt/lists/*

ADD container_files/install-nginx.sh /tmp/install-nginx.sh
# RUN  addgroup nginx && adduser --system --no-create-home --ingroup nginx nginx
RUN  addgroup nginx && adduser --system --no-create-home --ingroup nginx nginx && \
    /bin/sh /tmp/install-nginx.sh && \
    shib-keygen -f -u nginx && \
    usermod -aG nginx root

    # adduser --system --no-create-home --shell /bin/false --group --disabled-login www

# RUN GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 \
#     && CONFIG="\
#         --prefix=/etc/nginx \
#         --sbin-path=/usr/sbin/nginx \
#         --modules-path=/usr/lib/nginx/modules \
#         --conf-path=/etc/nginx/nginx.conf \
#         --error-log-path=/var/log/nginx/error.log \
#         --http-log-path=/var/log/nginx/access.log \
#         --pid-path=/var/run/nginx.pid \
#         --lock-path=/var/run/nginx.lock \
#         --http-client-body-temp-path=/var/cache/nginx/client_temp \
#         --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
#         --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
#         --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
#         --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
#         --user=nginx \
#         --group=nginx \
#         --with-http_ssl_module \
#         --with-http_realip_module \
#         --with-http_addition_module \
#         --with-http_sub_module \
#         --with-http_dav_module \
#         --with-http_flv_module \
#         --with-http_mp4_module \
#         --with-http_gunzip_module \
#         --with-http_gzip_static_module \
#         --with-http_random_index_module \
#         --with-http_secure_link_module \
#         --with-http_stub_status_module \
#         --with-http_auth_request_module \
#         --with-http_xslt_module=dynamic \
#         --with-http_image_filter_module=dynamic \
#         --with-http_geoip_module=dynamic \
#         --with-threads \
#         --with-stream \
#         --with-stream_ssl_module \
#         --with-stream_ssl_preread_module \
#         --with-stream_realip_module \
#         --with-stream_geoip_module=dynamic \
#         --with-http_slice_module \
#         --with-mail \
#         --with-mail_ssl_module \
#         --with-compat \
#         --with-file-aio \
#         --with-http_v2_module \
#     " \
#     && addgroup -S nginx \
#     && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
#     && apk add --no-cache --virtual .build-deps \
#         gcc \
#         libc-dev \
#         make \
#         openssl-dev \
#         pcre-dev \
#         zlib-dev \
#         linux-headers \
#         curl \
#         gnupg \
#         libxslt-dev \
#         gd-dev \
#         geoip-dev \
#     && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
#     && curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc \
#     && export GNUPGHOME="$(mktemp -d)" \
#     && found=''; \
#     for server in \
#         ha.pool.sks-keyservers.net \
#         hkp://keyserver.ubuntu.com:80 \
#         hkp://p80.pool.sks-keyservers.net:80 \
#         pgp.mit.edu \
#     ; do \
#         echo "Fetching GPG key $GPG_KEYS from $server"; \
#         gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$GPG_KEYS" && found=yes && break; \
#     done; \
#     test -z "$found" && echo >&2 "error: failed to fetch GPG key $GPG_KEYS" && exit 1; \
#     gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz \
#     && rm -r "$GNUPGHOME" nginx.tar.gz.asc \
#     && mkdir -p /usr/src \
#     && tar -zxC /usr/src -f nginx.tar.gz \
#     && rm nginx.tar.gz \
#     && cd /usr/src/nginx-$NGINX_VERSION \
#     && ./configure $CONFIG --with-debug \
#     && make -j$(getconf _NPROCESSORS_ONLN) \
#     && mv objs/nginx objs/nginx-debug \
#     && mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
#     && mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
#     && mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
#     && mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
#     && ./configure $CONFIG \
#     && make -j$(getconf _NPROCESSORS_ONLN) \
#     && make install \
#     && rm -rf /etc/nginx/html/ \
#     && mkdir /etc/nginx/conf.d/ \
#     && mkdir -p /usr/share/nginx/html/ \
#     && install -m644 html/index.html /usr/share/nginx/html/ \
#     && install -m644 html/50x.html /usr/share/nginx/html/ \
#     && install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
#     && install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
#     && install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
#     && install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
#     && install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
#     && ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
#     && strip /usr/sbin/nginx* \
#     && strip /usr/lib/nginx/modules/*.so \
#     && rm -rf /usr/src/nginx-$NGINX_VERSION \
#     \
#     # Bring in gettext so we can get `envsubst`, then throw
#     # the rest away. To do this, we need to install `gettext`
#     # then move `envsubst` out of the way so `gettext` can
#     # be deleted completely, then move `envsubst` back.
#     && apk add --no-cache --virtual .gettext gettext \
#     && mv /usr/bin/envsubst /tmp/ \
#     \
#     && runDeps="$( \
#         scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
#             | tr ',' '\n' \
#             | sort -u \
#             | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
#     )" \
#     && apk add --no-cache --virtual .nginx-rundeps $runDeps \
#     && apk del .build-deps \
#     && apk del .gettext \
#     && mv /tmp/envsubst /usr/local/bin/ \
#     \
#     # forward request and error logs to docker log collector
#     && ln -sf /dev/stdout /var/log/nginx/access.log \
#     && ln -sf /dev/stderr /var/log/nginx/error.log

COPY container_files /

EXPOSE 80

STOPSIGNAL SIGTERM

# CMD ["nginx", "-g", "daemon off;"]

