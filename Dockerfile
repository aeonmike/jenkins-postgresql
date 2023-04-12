FROM rockylinux/rockylinux:latest

ARG POSTGRES_PASSWORD

RUN dnf update -y && \
    dnf install -y postgresql-server && \
    dnf clean all && \
    rm -rf /var/cache/dnf/*

RUN /usr/bin/postgresql-setup --initdb

# Edit pg_hba.conf to use MD5 authentication
RUN sed -i 's/ident/md5/g' /var/lib/pgsql/data/pg_hba.conf

# Edit postgresql.conf to listen on all addresses
RUN echo "listen_addresses = '*'" >> /var/lib/pgsql/data/postgresql.conf

# Set the password for the postgres user
RUN echo "alter user postgres with password '${POSTGRES_PASSWORD}';" | \
    /usr/bin/postgres --single -D /var/lib/pgsql/data

# Expose the PostgreSQL port
EXPOSE 5432

# Start PostgreSQL
CMD ["/usr/bin/pg_ctl", "start", "-D", "/var/lib/pgsql/data", "-l", "/var/lib/pgsql/pg.log", "-s"]

# Set the default user to run the container
USER root
