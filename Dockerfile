FROM ubuntu

# Update and add repositories
RUN apt-get update && apt-get install software-properties-common -y
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

# Install tzdata noninteractive
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Update and install Ansible and PHP 7.2
RUN apt-get update && apt-get install -y --allow-unauthenticated ansible php7.2 php7.2-gd php7.2-xmlwriter php7.2-iconv php7.2-mbstring php7.2-zip php7.2-sqlite3 php7.2-mysql php7.2-curl

# Install Composer.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

# Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit-7.2.6.phar
RUN chmod +x phpunit-7.2.6.phar
RUN mv phpunit-7.2.6.phar /usr/local/bin/phpunit

# Ignore fingerprint
RUN sed -i '11i\host_key_checking = False' /etc/ansible/ansible.cfg
