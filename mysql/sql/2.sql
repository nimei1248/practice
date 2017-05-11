[统计连接帐号]

SELECT
    ess.user,
    ess.host,
    (a.total_connections - a.current_connections) - ess.count_star AS not_closed,
    ((a.total_connections - a.current_connections) - ess.count_star) * 100 / (a.total_connections - a.current_connections) AS pct_not_closed
FROM
    performance_schema.events_statements_summary_by_account_by_event_name ess
        JOIN
    performance_schema.accounts a ON (ess.user = a.user AND ess.host = a.host)
WHERE
    ess.event_name = 'statement/com/quit'
        AND (a.total_connections - a.current_connections) > ess.count_star;

+----------+----------------+------------+----------------+
| user     | host           | not_closed | pct_not_closed |
+----------+----------------+------------+----------------+
| repuser  | 172.15.13.64   |         10 |       100.0000 |
| sys      | localhost      |        106 |        13.1026 |
| squirrel | 10.252.252.102 |        438 |        83.9080 |
| cow      | 172.15.4.196   |          6 |        11.5385 |
| cow      | 10.140.50.176  |        728 |         0.2850 |
| squirrel | 10.140.50.176  |        275 |         0.0633 |
| squirrel | 10.160.70.37   |        770 |         0.4726 |
+----------+----------------+------------+----------------+




[查询被使用的索引]

SELECT
    object_schema, object_name, index_name
FROM
    performance_schema.table_io_waits_summary_by_index_usage
WHERE
    index_name IS NOT NULL
        AND index_name != 'PRIMARY'
        AND count_star = 0
ORDER BY object_schema , object_name;


+---------------+---------------+------------+
| object_schema | object_name   | index_name |
+---------------+---------------+------------+
| mysql         | db            | User       |
| mysql         | help_category | name       |
| mysql         | help_keyword  | name       |
| mysql         | help_topic    | name       |
| mysql         | procs_priv    | Grantor    |
| mysql         | proxies_priv  | Grantor    |
| mysql         | tables_priv   | Grantor    |
+---------------+---------------+------------+




[查询长时间运行的sql]

use performance_schema;
UPDATE setup_consumers
SET
    enabled = 'ON'
WHERE
    name = 'events_statements_history_long';

SELECT
    LEFT(digest_text, 64),
    ROUND(SUM(timer_end - timer_start) / 1000000000,
            1) AS total_exec_ms,
    ROUND(SUM(timer_end - timer_start) / 1000000000 / COUNT(*),
            1) AS avg_exec_ms,
    ROUND(MIN(timer_end - timer_start) / 1000000000,
            1) AS min_exec_ms,
    ROUND(MAX(timer_end - timer_start) / 1000000000,
            1) AS max_exec_ms,
    ROUND(SUM(timer_wait) / 1000000000, 1) AS total_wait_ms,
    ROUND(SUM(timer_wait) / 1000000000 / COUNT(*),
            1) AS avg_wait_ms,
    ROUND(MIN(timer_wait) / 1000000000, 1) AS min_wait_ms,
    ROUND(MAX(timer_wait) / 1000000000, 1) AS max_wait_ms,
    ROUND(SUM(lock_time) / 1000000000, 1) AS total_lock_ms,
    ROUND(SUM(lock_time) / 1000000000 / COUNT(*),
            1) AS avg_lock_ms,
    ROUND(MIN(lock_time) / 1000000000, 1) AS min_lock_ms,
    ROUND(MAX(lock_time) / 1000000000, 1) AS max_lock_ms,
    MIN(LEFT(DATE_SUB(NOW(),
            INTERVAL (a.VARIABLE_VALUE - TIMER_START * 10E-13) SECOND),
        19)) AS first_seen,
    MAX(LEFT(DATE_SUB(NOW(),
            INTERVAL (a.VARIABLE_VALUE - TIMER_START * 10E-13) SECOND),
        19)) AS last_seen,
    COUNT(*) AS cnt
FROM
    events_statements_history_long
        JOIN
    information_schema.global_status AS a
WHERE
    a.variable_name = 'UPTIME'
GROUP BY LEFT(digest_text, 64)
ORDER BY total_exec_ms DESC;
