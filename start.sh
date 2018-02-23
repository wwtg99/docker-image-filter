#!/bin/sh
#########################################################################
# File Name: start.sh
# Author: wwtg99
# Email:  wwtg99@126.com
# Version:
# Created Time: 2018/02/12
#########################################################################

# add default nginx server config
Nginx_Conf=/data/conf/nginx
DATA_DIR=/data/www
SERVER_DIR=/data/server/server

set -e
chown -R www:www $DATA_DIR
chmod -R 775 /var/lib/nginx
ln -s $SERVER_DIR $DATA_DIR/server

if [[ ! -f "${Nginx_Conf}/website.conf" ]]; then

	echo 'Create image filter server config file.'

	if [ "$DOMAIN" = "" ]; then
		DOMAIN='localhost'
	fi

	cat > ${Nginx_Conf}/website.conf << EOF
server {
    listen 80;
    server_name $DOMAIN;

    root   $DATA_DIR/server/public;
    index  index.php index.html;

    location / {
       try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 8 128k;
        fastcgi_connect_timeout 120s;
        fastcgi_send_timeout 120s;
        fastcgi_read_timeout 120s;
    }

    location ~ /\.ht {
        deny  all;
    }
}
EOF
fi

# Set config file
cat > $SERVER_DIR/.env << EOF
APP_NAME="Image Filter"
APP_ENV=local
APP_KEY=
APP_DEBUG=false
APP_LOG=daily
APP_LOG_LEVEL=info

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

BROADCAST_DRIVER=log
CACHE_DRIVER=$CACHE_DRIVER
SESSION_DRIVER=$SESSION_DRIVER
SESSION_LIFETIME=120
QUEUE_DRIVER=sync

REDIS_HOST=$REDIS_HOST
REDIS_PASSWORD=$REDIS_PWD
REDIS_PORT=$REDIS_PORT

IMAGE_FILTER_PATH="export PATH=\"PATH:/data/server/image_filter\" && /usr/local/bin/python3 /data/server/image_filter/image_filter.py"
EOF

php $SERVER_DIR/artisan key:generate
php $SERVER_DIR/artisan storage:link

# run user script
if [[ -f "/data/script/script.sh" ]]; then
  source /data/script/script.sh
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
