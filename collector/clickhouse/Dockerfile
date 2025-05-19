FROM yandex/clickhouse-server:latest

COPY config.xml /etc/clickhouse-server/config.xml
COPY init.sql /docker-entrypoint-initdb.d/init.sql
