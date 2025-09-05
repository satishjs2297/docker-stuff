#!/bin/bash
set -e

# Start Postgres in background
su - postgres -c "/usr/lib/postgresql/${POSTGRES_VERSION}/bin/postgres -D ${PGDATA}" &

# Wait for Postgres to be ready
until pg_isready -h localhost -p 5432 -U "$POSTGRES_USER"; do
  echo "Waiting for Postgres..."
  sleep 2
done

echo "Postgres is up. Running Flyway migrations..."

flyway -url=jdbc:postgresql://localhost:5432/$POSTGRES_DB -user=$POSTGRES_USER -password=$POSTGRES_PASSWORD migrate

# Keep container alive (Postgres already running in background)
wait -n
