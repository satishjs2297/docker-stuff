#!/bin/sh
set -e

# Initialize database if not done
if [ ! -d "$PGDATA/base" ]; then
  echo "Initializing PostgreSQL database..."
  /usr/local/pgsql/bin/initdb -D "$PGDATA"
fi

# Start Postgres in background
/usr/local/pgsql/bin/postgres -D "$PGDATA" &

# Wait until Postgres is ready
until /usr/local/pgsql/bin/pg_isready -h localhost -p 5432 -U "$POSTGRES_USER"; do
  echo "Waiting for Postgres..."
  sleep 2
done

echo "Postgres is ready. Running Flyway..."
flyway -url=jdbc:postgresql://localhost:5432/$POSTGRES_DB -user=$POSTGRES_USER -password=$POSTGRES_PASSWORD migrate

# Keep container alive with Postgres
wait -n
