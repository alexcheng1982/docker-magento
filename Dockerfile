FROM occitech/magento:php5.5-apache

ENV MAGENTO_VERSION 1.7.0.2

RUN cd /tmp && curl https://codeload.github.com/OpenMage/magento-mirror/tar.gz/$MAGENTO_VERSION -o $MAGENTO_VERSION.tar.gz && tar xvf $MAGENTO_VERSION.tar.gz && mv magento-mirror-$MAGENTO_VERSION/* magento-mirror-$MAGENTO_VERSION/.htaccess /var/www/htdocs

RUN chown -R www-data:www-data /var/www/htdocs

RUN apt-get update && apt-get install -y mysql-client-5.5 libxml2-dev patch
RUN docker-php-ext-install soap

COPY ./bin/install-magento /usr/local/bin/install-magento

RUN chmod +x /usr/local/bin/install-magento

# Apply patches
COPY ./patches/*.sh /var/www/htdocs/
RUN cd /var/www/htdocs && /bin/bash PATCH_SUPEE-2629_EE_1.12.0.0_v1-2015-02-12-04-30-34.sh

# Apply Mysql 5.6 support
COPY ./patches/Mysql4.php /opt/
RUN chown www-data:www-data /opt/Mysql4.php
COPY ./bin/enable-mysql-5.6-support /usr/local/bin/enable-mysql-5.6-support
RUN chmod +x /usr/local/bin/enable-mysql-5.6-support

VOLUME /var/www/htdocs
