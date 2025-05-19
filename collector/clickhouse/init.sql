CREATE TABLE IF NOT EXISTS logs (
    timestamp DateTime,
    tag String,
    remote String,
    host String,
    user String,
    method String,
    path String,
    code UInt16,
    size UInt64,
    referer String,
    agent String,
    pri UInt8,
    ident String,
    pid UInt32,
    msg String
) ENGINE = MergeTree()
ORDER BY timestamp;
