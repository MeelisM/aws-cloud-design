#!/bin/bash
set -e

echo "===== Environment Variables ====="
env
echo "================================"

# Exit if required environment variables aren't set
[ -z "$BILLING_DB_USER" ] && echo "BILLING_DB_USER not set" && exit 1
[ -z "$BILLING_DB_PASSWORD" ] && echo "BILLING_DB_PASSWORD not set" && exit 1
[ -z "$BILLING_DB_NAME" ] && echo "BILLING_DB_NAME not set" && exit 1

# Connect to PostgreSQL and create the user and database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
    ALTER USER postgres WITH PASSWORD '$BILLING_POSTGRES_PASSWORD';
    CREATE USER $BILLING_DB_USER WITH SUPERUSER PASSWORD '$BILLING_DB_PASSWORD';
    CREATE DATABASE $BILLING_DB_NAME OWNER $BILLING_DB_USER;
    GRANT ALL PRIVILEGES ON DATABASE $BILLING_DB_NAME TO $BILLING_DB_USER;
EOSQL

# Configure PostgreSQL to allow remote connections
echo "listen_addresses = '*'" >> /var/lib/postgresql/data/postgresql.conf
echo "host all all all md5" >> /var/lib/postgresql/data/pg_hba.conf