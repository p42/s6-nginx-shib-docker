#!/usr/bin/with-contenv /bin/sh

# Download and execute envplate to set up the variables in our config files.
curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux
chmod +x /usr/local/bin/ep

ep -v /etc/nginx/conf.d/shib.conf /etc/shibboleth/shibboleth2.xml /usr/share/nginx/html/index.php

chown nginx /etc/.logpasswd