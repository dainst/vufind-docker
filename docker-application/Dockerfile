FROM ubuntu:18.04


ENV REFRESHED_AT 2019-06-11
LABEL maintainer="Deutsches Archäologisches Institut: dev@dainst.de"
LABEL "installation instructions"="https://vufind.org/wiki/installation:ubuntu#detailed_installation_instructions"

ENV DEBIAN_FRONTEND noninteractive
ENV APACHE_DOMAIN_NAME localhost

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get clean

# 0. Install base config:
RUN apt-get install -y \
	apt-utils \
	wget \
	nano \
	curl \
	git \
	man \
	lsof \
	zip \
	unzip \
&& apt-get update && apt-get dist-upgrade -y && apt-get clean

# 1. Install Apache HTTP Server:
RUN apt-get install -y apache2
RUN echo "ServerName" $APACHE_DOMAIN_NAME | tee /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn.conf
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http

# 2. Install PHP:
RUN apt-get install software-properties-common -y
RUN apt-get update && apt-get dist-upgrade -y && apt-get clean
RUN apt-get install -y \
	libapache2-mod-php php-mbstring php-pear php php-dev php-gd php-intl php-json php-ldap php-mysql php-xml php-soap php-curl

# Install Xdebug
RUN apt-get install php-xdebug

# 3. Install the Java JDK:
RUN apt-get install -y openjdk-8-jdk
RUN update-alternatives --config java
RUN update-alternatives --config javac

# 4. Set Up Environment Variables:
ENV VUFIND_HOME /usr/local/vufind
ENV VUFIND_LOCAL_DIR /usr/local/vufind/local

# VuFind cache directory can't stay the default (/usr/local/vufind/local/cache) because we want to mount the repository
# at /usr/local/vufind on container startup. The volume mount process would set the complete folder tree to user/group
# "root", which finally would prevent the Apache from accessing it.
ENV VUFIND_CACHE_DIR /tmp/vufind_cache

RUN mkdir ${VUFIND_CACHE_DIR}
RUN mkdir ${VUFIND_CACHE_DIR}/cli
RUN chown -R www-data:www-data ${VUFIND_CACHE_DIR}
RUN chmod 777 ${VUFIND_CACHE_DIR}/cli

# Can be removed when finally switching to Koha branch. Ruby is used to preprocess data harvested from Aleph and the
# old status email. --->
RUN apt-get install -y \
    build-essential ruby ruby-dev

RUN gem install marc
# <----!

EXPOSE 80

WORKDIR /usr/local/vufind

COPY docker-application/docker-entrypoint.sh /


ENTRYPOINT ["/docker-entrypoint.sh"]
