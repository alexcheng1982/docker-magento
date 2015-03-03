FROM occitech/magento:php5.5-apache

RUN cd /tmp && curl -O http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-1.9.1.0.tar.gz && tar xvf magento-1.9.1.0.tar.gz && mv magento/* /var/www/htdocs

RUN chown -R www-data:www-data /var/www/htdocs

COPY ./bin/install-magento /usr/local/bin/install-magento

RUN chmod +x /usr/local/bin/install-magento
