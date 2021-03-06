# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#####################################################################################

# work around for AUFS bug
# as per https://github.com/docker/docker/issues/783#issuecomment-56013588
RUN echo "mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private" >> /etc/my_init.d/00_regen_ssh_host_keys.sh

# work around for AUFS bug
# as per https://github.com/docker/docker/issues/783#issuecomment-56013588
# RUN chmod -R 700 /etc/ssl/private; chown -R postgres /etc/ssl/private

#####################################################################################

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN echo "Add PostgreSQL's repository to source list"
# Add PostgreSQL's repository. It contains the most recent stable release
#     of PostgreSQL, ``9.3``.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list


RUN echo "Update the Ubuntu and PostgreSQL repository indexes and install"
# Update the Ubuntu and PostgreSQL repository indexes and install ``python-software-properties``,``software-properties-common`` and PostgreSQL 9.3
# There are some warnings (in red) that show up during the build. You can hide
# them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get -y -q install python-software-properties software-properties-common 
RUN apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3


RUN echo "Init PostgreSQL DB schema"
# copy sql scripts for create and intialize dbmiannotator and mpevidence
RUN mkdir -p /home/postgres/db-schema
COPY db-schema/rdb-postgres-schema.sql /home/postgres/db-schema/rdb-postgres-schema.sql
COPY db-schema/rdb-postgres-initial.sql /home/postgres/db-schema/rdb-postgres-initial.sql
COPY db-schema/mp_evidence_schema.sql /home/postgres/db-schema/mp_evidence_schema.sql

# create database dbmiannotator, create tables, initial plugins 
# create database mpevidence, create tables
USER postgres

RUN /etc/init.d/postgresql start && sleep 8 \
    && psql --command "CREATE USER dbmiannotator WITH SUPERUSER PASSWORD 'dbmi2016';" \
    && createdb -O dbmiannotator dbmiannotator dbmi2016 \ 
    && psql --command "\c dbmiannotator;" \ 
    && psql -d dbmiannotator --command "\i '/home/postgres/db-schema/rdb-postgres-schema.sql';" \ 
    && psql -d dbmiannotator --command "\i '/home/postgres/db-schema/rdb-postgres-initial.sql';" \
    && psql --command "commit;" \

    && createdb -O dbmiannotator mpevidence dbmi2016 \ 
    && psql --command "\c mpevidence;" \
    && psql -d mpevidence --command "\i '/home/postgres/db-schema/mp_evidence_schema.sql';" \
    && psql --command "commit;"


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

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

