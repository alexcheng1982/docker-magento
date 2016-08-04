FROM occitech/magento:php5.5-apache

ENV MAGENTO_VERSION 1.9.2.4

RUN apt-get update && apt-get install -y mysql-client-5.5 libxml2-dev
RUN docker-php-ext-install soap

COPY ./bin/entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

USER 1000

ENTRYPOINT entrypoint
