FROM mysql:5.7


ENV REFRESHED_AT 2018-05-16
LABEL maintainer="Deutsches Archäologisches Institut: dev@dainst.de"

ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE_NAME
ARG MYSQL_USER_NAME
ARG MYSQL_USER_PASSWORD

RUN echo "CREATE DATABASE ${MYSQL_DATABASE_NAME};" > /docker-entrypoint-initdb.d/01_create_database.sql
RUN echo "GRANT SELECT,INSERT,UPDATE,DELETE ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER_NAME}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}' WITH GRANT OPTION; \
          GRANT SELECT,INSERT,UPDATE,DELETE ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}' WITH GRANT OPTION; \
          FLUSH PRIVILEGES;" > /docker-entrypoint-initdb.d/02_create_user.sql


COPY docker-db/setup_database.sql /setup_database.sql
RUN echo "USE ${MYSQL_DATABASE_NAME};" | cat - /setup_database.sql > /docker-entrypoint-initdb.d/03_setup_database.sql

EXPOSE 3306

