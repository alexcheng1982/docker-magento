FROM occitech/magento:php5.5-apache

RUN cd /tmp && curl -O http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz && tar xvf magento-1.9.1.0.tar.gz && mv magento/* magento/.htaccess /var/www/htdocs

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
