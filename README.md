# Docker image for Magento

This repo creates a Docker image for [Magento](http://magento.com/).

## How to use

### Use `docker run`

You can use `docker run` to run this image directly.

```bash
docker run -p 80:80 alexcheng/magento
```

Then finish Magento installation using web UI.

Magento is installed into `/var/www/htdocs` folder.

### Use Docker Compose

[Docker Compose](https://docs.docker.com/compose/) is another way to run this image with MySQL database.

A sample `docker-compose.yml` can be found in this repo.

```yaml
web:
  image: alexcheng/magento
  ports:
    - "80:80"
  links:
    - mysql
  env_file:
    - env
mysql:
  image: mysql:5.6.23
  env_file:
    - env
```

Then use `docker-compose up` to start MySQL and Magento server.

## Magento install script

A Magento install script is also provided as `install-magento`. This script requires certain environment variables to run:

Environment variable      | Description
--------------------      | -----------
MYSQL_HOST                | MySQL host
MYSQL_DATABASE            | MySQL db name for Magento
MYSQL_USER                | MySQL username
MYSQL_PASSWORD            | MySQL password
MAGENTO_LOCALE            | Magento locale
MAGENTO_TIMEZONE          | Magento timezone
MAGENTO_DEFAULT_CURRENCY  | Magento default currency
MAGENTO_URL               | Magento base url
MAGENTO_ADMIN_FIRSTNAME   | Magento admin firstname
MAGENTO_ADMIN_LASTNAME    | Magento admin lastname
MAGENTO_ADMIN_EMAIL       | Magento admin email
MAGENTO_ADMIN_USERNAME    | Magento admin username
MAGENTO_ADMIN_PASSWORD    | Magento admin password

If you want to use `install-magento` script, make sure these environment variables are passed in `docker run` with `-e` switch.

After Docker container started, use `docker ps` to find container id of image `alexcheng/magento`, then use `docker exec` to call `install-magento` script.

```bash
docker exec -it <container id> install-magento
```

If Docker compose is used, you can just modify `env` file in the same directory of `docker-compose.yml` file to update those environment variables.

After calling `install-magento`, Magento is installed and ready to use. Use provided admin username and password to log into Magento backend.
