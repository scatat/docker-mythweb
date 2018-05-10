FROM ubuntu:16.04

VOLUME /etc/apache2/sites-available

RUN apt-get update && \
    apt-get install -qy software-properties-common && \
    apt-key adv --recv-key --keyserver keyserver.ubuntu.com 1504888C && \
    add-apt-repository ppa:mythbuntu/0.29 && \
    apt-get update -q && \
    echo "mythweb mythweb/only boolean true" | debconf-set-selections && \
    echo "mythweb mythweb/enable boolean false" | debconf-set-selections && \
    apt-get install -y mythweb  && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y

ENV APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid

EXPOSE 80

CMD tail -F /var/log/apache2/*.log & /usr/sbin/apache2 -D FOREGROUND
