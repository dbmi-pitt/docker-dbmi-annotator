FROM ubuntu:14.04
MAINTAINER Yifan Ning <yin2@pitt.edu>

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Update the Ubuntu and PostgreSQL repository indexes and install ``python-software-properties``,``software-properties-common`` and PostgreSQL 9.3
# There are some warnings (in red) that show up during the build. You can hide
# them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y -q install python-software-properties software-properties-common \
    && apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

# copy sql scripts for create and intialize dbmiannotator database
RUN mkdir -p /home/yin2/db-schema
COPY db-schema/rdb-postgres-schema.sql /home/yin2/db-schema/rdb-postgres-schema.sql
COPY db-schema/rdb-postgres-initial.sql /home/yin2/db-schema/rdb-postgres-initial.sql

# create dbmiannotator, create tables, initial plugins 
USER postgres

RUN /etc/init.d/postgresql start && sleep 8 \
    && psql --command "CREATE USER dbmiannotator WITH SUPERUSER PASSWORD 'dbmi2016';" \
    && createdb -O dbmiannotator dbmiannotator dbmi2016 \ 
    && psql --command "\c dbmiannotator;" \ 
    && psql -d dbmiannotator --command "\i '/home/yin2/db-schema/rdb-postgres-schema.sql';" \ 
    && psql -d dbmiannotator --command "\i '/home/yin2/db-schema/rdb-postgres-initial.sql';" \ 
    && psql --command "commit;"

USER root

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql/9.3/main"]

RUN mkdir -p /var/lib/postgresql/9.3/main && chown -R postgres:postgres /var/lib/postgresql && chmod -R 700 /var/lib/postgresql

USER postgres

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]