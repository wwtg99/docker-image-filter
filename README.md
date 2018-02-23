# docker-image-filter

## Description
Docker image for [image_filter_server](https://github.com/wwtg99/image_filter_server) and [image_filter tool](https://github.com/wwtg99/image_filter). It is quickly to build a image filter demo service.

## Usage
Run image

```
docker run -d --name image-filter -p 8080:80  wwtg99/docker-image-filter:latest
```

Other usages refers to base image [docker-nginx-php](https://hub.docker.com/r/wwtg99/docker-nginx-php7).

## Environment
Config service for image_filter_server (see [Laravel](https://laravel.com/docs/5.6/configuration)). No need to change for most case.

- CACHE_DRIVER
- SESSION_DRIVER
- REDIS_HOST
- REDIS_PWD
- REDIS_PORT

Set timezone: TZ

```
docker run -d --name image-filter -p 8080:80 -e "TZ=Asia/Shanghai"  wwtg99/docker-image-filter:latest
```

Set server domain for default config: DOMAIN

```
docker run -d --name image-filter -p 8080:80 -e "DOMAIN=test.com"  wwtg99/docker-image-filter:latest
```

Note, it is only useful for auto generated nginx config.

## Scripts
Support custom script, please see base image [docker-nginx-php](https://hub.docker.com/r/wwtg99/docker-nginx-php7).

## Author
[wwtg99](http://52jing.wang)
