FROM occitech/magento:php5.5-apache

RUN cd /tmp && curl https://codeload.github.com/OpenMage/magento-mirror/tar.gz/1.9.1.0 -o 1.9.1.0.tar.gz && tar xvf 1.9.1.0.tar.gz && mv magento-mirror-1.9.1.0/* magento-mirror-1.9.1.0/.htaccess /var/www/htdocs

RUN chown -R www-data:www-data /var/www/htdocs

RUN apt-get update
RUN apt-get install -y mysql-client-5.5
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

COPY ./bin/install-magento /usr/local/bin/install-magento

RUN chmod +x /usr/local/bin/install-magento

COPY ./sampledata/magento-sample-data-1.9.1.0.tgz /opt/
COPY ./bin/install-sampledata-1.9 /usr/local/bin/install-sampledata
RUN chmod +x /usr/local/bin/install-sampledata
