#!/bin/sh
# wait-for-postgres.sh

set -e

host="$1"
shift
cmd="$@"

echo "------"
echo "$host"
echo "$POSTGRES_USER"
echo "$POSTGRES_PASSWORD"
echo "$POSTGRES_DB"
echo "$POSTGRES_HOST"
echo "$POSTGRES_PORT"
echo "======"

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd