#!/bin/bash
set -e

echo "===== Environment Variables ====="
env
echo "================================"

# Exit if required environment variables aren't set
[ -z "$INVENTORY_DB_USER" ] && echo "INVENTORY_DB_USER not set" && exit 1
[ -z "$INVENTORY_DB_PASSWORD" ] && echo "INVENTORY_DB_PASSWORD not set" && exit 1
[ -z "$INVENTORY_DB_NAME" ] && echo "INVENTORY_DB_NAME not set" && exit 1

# Connect to PostgreSQL and create the user and database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
    ALTER USER postgres WITH PASSWORD '$INVENTORY_POSTGRES_PASSWORD';
    CREATE USER $INVENTORY_DB_USER WITH SUPERUSER PASSWORD '$INVENTORY_DB_PASSWORD';
    CREATE DATABASE $INVENTORY_DB_NAME OWNER $INVENTORY_DB_USER;
    GRANT ALL PRIVILEGES ON DATABASE $INVENTORY_DB_NAME TO $INVENTORY_DB_USER;
EOSQL

# Configure PostgreSQL to allow remote connections
echo "listen_addresses = '*'" >> /var/lib/postgresql/data/postgresql.conf
echo "host all all all md5" >> /var/lib/postgresql/data/pg_hba.conf