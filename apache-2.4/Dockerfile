FROM ubuntu:14.04
 
# Define environment variables
#ENV DEBIAN_FRONTEND noninteractive
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
 
# Install apache2 server
RUN apt-get update \
    && apt-get install -y --no-install-recommends apache2 \
                            libapache2-mod-jk
VOLUME ["/var/log/apache2", "/etc/apache2"]

# enable rewrite module
RUN a2enmod rewrite

# copy apache2 configuration to docker
# remove default config
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
RUN rm -rf /etc/apache2/sites-available/000-default.conf
COPY dbmi-annotator.conf /etc/apache2/sites-enabled/

# copy local html resources to root directory
RUN mkdir /var/www/html/dailymed
RUN mkdir /var/www/html/DDI-labels
COPY dailymed/ /var/www/html/dailymed/
COPY DDI-labels/ /var/www/html/DDI-labels/

# debug
#RUN ls -la /var/www/html/dailymed/*
RUN ls /etc/apache2/sites-enabled/*
RUN ls /etc/apache2/sites-available/*

# set up server name

COPY localhost.conf /etc/apache2/conf-available/
RUN a2enconf localhost

#RUN apache2ctl graceful
RUN service apache2 restart

#EXPOSE 80

# Start apache2 server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]