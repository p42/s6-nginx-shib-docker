
FROM debian:wheezy

# See https://github.com/nginx-shib/nginx-http-shibboleth/blob/master/CONFIG.rst

RUN echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y -t \
      wheezy-backports \
      opensaml2-schemas \
      xmltooling-schemas \
      libshibsp6 \
      libshibsp-plugins \
      shibboleth-sp2-common \
      shibboleth-sp2-utils \
      supervisor \
      procps \
      curl \
      git \
      build-essential \
      libpcre3 \
      libpcre3-dev \
      libpcrecpp0 \
      libssl-dev \
      zlib1g-dev \
      lua5.1 \
      liblua5.1-0-dev \
      liblua5.1-socket2 \
    && ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/lib/liblua.so \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/lib/lua/5.1 \
    && curl https://raw.githubusercontent.com/nrk/redis-lua/version-2.0/src/redis.lua -o /usr/local/lib/lua/5.1/redis.lua

# Copy supervisor config files
COPY supervisor /etc/supervisor

# Copy shibboleth config directory
COPY shibboleth /etc/shibboleth

# Build and install nginx
ARG NGINX_VERSION="1.11.6"
ARG MORE_HEADERS_VERSION="0.32"
ARG ECHO_VERSION="0.60"
ARG NGINX_SHIB_VERSION="2.0.0"
ARG LUA_VERSION="0.10.7"

ADD ./build-nginx.sh /tmp/build-nginx.sh
RUN /bin/bash /tmp/build-nginx.sh $NGINX_VERSION $MORE_HEADERS_VERSION $ECHO_VERSION $NGINX_SHIB_VERSION $LUA_VERSION

# Copy nginx config files
COPY nginx /etc/nginx

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Create missing dirs and generate shibboleth keys
RUN mkdir /var/run/shibboleth /var/log/shibboleth /var/cache/nginx || true && shib-keygen -f

# Set permissions
RUN chown -R _shibd /var/log/nginx /var/cache/nginx

# Get envplate
# @see https://github.com/kreuzwerker/envplate
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.7/ep-linux \
    && chmod +x /usr/local/bin/ep

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443 9090

CMD ["/usr/local/bin/ep", "-v", "/etc/nginx/conf.d/default.conf", "/etc/shibboleth/shibboleth2.xml", "--", "/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisor/supervisord.conf"]
