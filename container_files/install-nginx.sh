#!/usr/bin/with-contenv /bin/sh

NGINX_VERSION=${1:-"1.13.7"}
MORE_HEADERS_VERSION=${2:-"0.33"}
ECHO_VERSION=${3:-"0.61"}
NGINX_SHIB_VERSION=${4:-"2.0.1"}
# LUA_VERSION=${5:-"0.10.7"}

echo "Installing nginx version nginx:$NGINX_VERSION"

echo "This is where we do things"

# curl -L "https://nginx.org/download/nginx-1.11.6.tar.gz" | tar xz
echo "Download nginx:"
curl -L "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" | tar xz
echo "Download more headers:"
curl -L "https://github.com/openresty/headers-more-nginx-module/archive/v${MORE_HEADERS_VERSION}.tar.gz" | tar xz
echo "Download Echo:"
curl -L "https://github.com/openresty/echo-nginx-module/archive/v${ECHO_VERSION}.tar.gz" | tar xz
# curl -L "https://github.com/openresty/lua-nginx-module/archive/v${LUA_VERSION}.tar.gz" | tar xz
echo "Download Shibboleth:"
curl -L "https://github.com/nginx-shib/nginx-http-shibboleth/archive/v${NGINX_SHIB_VERSION}.tar.gz" | tar xz
echo "Change directories into what will become our working directory of nginx-${NGINX_VERSION}."
cd nginx-${NGINX_VERSION}
echo "Listing the directories above our current level, which is: $(pwd)"
echo $(ls ../)
# cd ../

# mv objs/nginx objs/nginx-debug
# mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so
# mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so
# mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so
# mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so
# cd nginx-${NGINX_VERSION} && \
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
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
        --with-debug \
        --with-http_auth_request_module \
        --with-pcre \
        --add-module="../echo-nginx-module-${ECHO_VERSION}" \
        --add-module="../headers-more-nginx-module-${MORE_HEADERS_VERSION}" \
        --add-module="../nginx-http-shibboleth-${NGINX_SHIB_VERSION}"

    make -j2 && make install

    mkdir -p /var/run/shibboleth /var/log/shibboleth /var/cache/nginx /var/log/nginx
    chown -R nginx /var/cache/nginx /var/log/nginx

    ln -sf /dev/stdout /var/log/nginx/access.log 
    ln -sf /dev/stderr /var/log/nginx/error.log 
    rm -rf /etc/nginx/html/ 
    # mkdir /etc/nginx/conf.d/ 
    mkdir -p /usr/share/nginx/html/ 
    install -m644 html/index.html /usr/share/nginx/html/ 
    install -m644 html/50x.html /usr/share/nginx/html/ 
    install -m755 objs/nginx /usr/sbin/nginx
    install -m755 objs/ngx_http_xslt_filter_module.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module.so 
    install -m755 objs/ngx_http_image_filter_module.so /usr/lib/nginx/modules/ngx_http_image_filter_module.so 
    install -m755 objs/ngx_http_geoip_module.so /usr/lib/nginx/modules/ngx_http_geoip_module.so 
    install -m755 objs/ngx_stream_geoip_module.so /usr/lib/nginx/modules/ngx_stream_geoip_module.so 
    ln -s ../../usr/lib/nginx/modules /etc/nginx/modules

cd / 
rm -rf "nginx-${NGINX_VERSION}" \
    "echo-nginx-module-${ECHO_VERSION}" \
    "headers-more-nginx-module-${MORE_HEADERS_VERSION}" \
    "nginx-http-shibboleth-${NGINX_SHIB_VERSION}"
