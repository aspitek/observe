-- Table pour les métriques
CREATE TABLE metrics_log
(
    `timestamp` DateTime64(3, 'UTC'),
    `timestamp_date` DateTime MATERIALIZED toDateTime(timestamp),
    `host` LowCardinality(String),
    `service` LowCardinality(String),
    `metric_name` LowCardinality(String),
    `metric_value` Float64,
    `tags` Map(LowCardinality(String), String)
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(timestamp)
ORDER BY (metric_name, host, timestamp)
TTL timestamp_date + INTERVAL 30 DAY
SETTINGS index_granularity = 8192;


-- Table pour les logs textuels
CREATE TABLE logs_text
(
    `timestamp` DateTime64(3, 'UTC'),
    `timestamp_date` DateTime MATERIALIZED toDateTime(timestamp),
    `host` LowCardinality(String),
    `service` LowCardinality(String),
    `level` LowCardinality(String),
    `message` String,
    `tags` Map(LowCardinality(String), String)
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(timestamp)
ORDER BY (host, service, level, timestamp)
TTL timestamp_date + INTERVAL 30 DAY
SETTINGS index_granularity = 8192;


-- Ajout d'un index pour recherches textuelles sur message
ALTER TABLE logs_text ADD INDEX message_idx message TYPE tokenbf_v1(10240, 3, 0) GRANULARITY 4;