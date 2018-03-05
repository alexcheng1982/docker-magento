# Docker image for Magento 1.x

[![](https://images.microbadger.com/badges/image/alexcheng/magento.svg)](http://microbadger.com/images/alexcheng/magento)

[![Docker build](http://dockeri.co/image/alexcheng/magento)](https://hub.docker.com/r/alexcheng/magento/)

This repo creates a Docker image for [Magento 1.x](http://magento.com/).

#### Please note

> The primary goal of this repo is to create Docker images for Magento 1.x development and testing, especially for extensions and themes development. It lacks essential support for production deployment, e.g. Varnish and Redis. Use this wisely for production deployment.

> This repo is only for Magento 1.x. If you are looking for Magento 2.x, check out [alexcheng1982/docker-magento2](https://github.com/alexcheng1982/docker-magento2).

## Magento versions

Version | Git branch | Tag name
--------| ---------- |---------
1.9.3.8 | master     | latest
1.9.1.1 | 1.9.1.0    | 1.9.1.0
1.8.1.0 | 1.8.1.0    | 1.8.1.0
1.7.0.2 | 1.7.0.2    | 1.7.0.2
1.6.2.0 | 1.6.2.0    | 1.6.2.0

## How to use

### Use as standalone container

You can use `docker run` to run this image directly.

```bash
docker run -p 80:80 alexcheng/magento
```

Then finish Magento installation using web UI. You need to have an existing MySQL server.

Magento is installed into `/var/www/html` folder.

### Use Docker Compose

[Docker Compose](https://docs.docker.com/compose/) is the recommended way to run this image with MySQL database.

A sample `docker-compose.yml` can be found in this repo.

```yaml
version: '3.0'

services:
  web:
    image: alexcheng/magento
    ports:
      - "80:80"
    links:
      - db
    env_file:
      - env
  db:
    image: mysql:5.6.23
    volumes:
      - db-data:/var/lib/mysql/data
    env_file:
      - env
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - "8580:80"
    links:
      - db
volumes:
  db-data:
```

Then use `docker-compose up -d` to start MySQL and Magento server.

## Magento sample data

Installation script for Magento sample data is also provided.

__Please note:__ Sample data must be installed __before__ Magento itself.

Use `/usr/local/bin/install-sampledata` to install sample data for Magento.

```bash
docker exec -it <container id> install-sampledata
```

Magento 1.9 sample data is compressed version from [Vinai/compressed-magento-sample-data](https://github.com/Vinai/compressed-magento-sample-data). Magento 1.6 uses the [official sample data](http://devdocs.magento.com/guides/m1x/ce18-ee113/ht_magento-ce-sample.data.html).

For Magento 1.7 and 1.8, the sample data from 1.6 doesn't work properly as claimed in the offcial website and causes database errors, so the `install-sampledata` script is removed for 1.7 and 1.8.

## Magento installation script

A Magento installation script is also provided as `/usr/local/bin/install-magento`. This script can install Magento without using web UI. This script requires certain environment variables to run:

Environment variable      | Description | Default value (used by Docker Compose - `env` file)
--------------------      | ----------- | ---------------------------
MYSQL_HOST                | MySQL host  | mysql
MYSQL_DATABASE            | MySQL db name for Magento | magento
MYSQL_USER                | MySQL username | magento
MYSQL_PASSWORD            | MySQL password | magento
MAGENTO_LOCALE            | Magento locale | en_GB
MAGENTO_TIMEZONE          | Magento timezone |Pacific/Auckland
MAGENTO_DEFAULT_CURRENCY  | Magento default currency | NZD
MAGENTO_URL               | Magento base url | http://local.magento
MAGENTO_ADMIN_FIRSTNAME   | Magento admin firstname | Admin
MAGENTO_ADMIN_LASTNAME    | Magento admin lastname | MyStore
MAGENTO_ADMIN_EMAIL       | Magento admin email | admin@example.com
MAGENTO_ADMIN_USERNAME    | Magento admin username | admin
MAGENTO_ADMIN_PASSWORD    | Magento admin password | magentorocks1

If you want to use `install-magento` script and this images is started as a standalone container using `docker run`, make sure these environment variables are passed in `docker run` with `-e` switch.

After Docker container started, use `docker ps` to find container id of image `alexcheng/magento`, then use `docker exec` to call `install-magento` script.

```bash
docker exec -it <container id> install-magento
```

If Docker Compose is used, you can just modify `env` file in the same directory of `docker-compose.yml` file to update those environment variables.

After calling `install-magento`, Magento is installed and ready to use. Use provided admin username and password to log into Magento backend.

If you use default base url (http://local.magento) or other test url, you need to [modify your host file](http://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/) to map the host name to docker container. For Boot2Docker, use `boot2docker ip` to find the IP address.

**Important**: If you do not use the default `MAGENTO_URL` you must use a hostname that contains a dot within it (e.g `foo.bar`), otherwise the [Magento admin panel login won't work](http://magento.stackexchange.com/a/7773).

## Redis Cache

If you want to use Redis as Cache backend see comments in Dockerfile and bin/install-magento

## Modman
Modman is a [Magento module manager](https://github.com/colinmollenhour/modman) that allows you to leave your work siloed from the actual Magento codebase via symlinks. With modman, you can sync plugin or theme work without keeping a persistent volume (or using a hidden volume).

```bash
# from htdocs
modman init
modman link /path/to/plugin
```
And to update symlinks:
```bash
modman deploy
```
