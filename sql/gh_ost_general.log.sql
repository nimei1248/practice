1> 连接id=89:
2018-08-08T16:52:24.494965+08:00           89 Connect   sys@127.0.0.1 on db1 using TCP/IP
采用tcp方式连接到db1库

2018-08-08T16:52:24.495173+08:00           89 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:24.495313+08:00           89 Query     SET autocommit=true
2018-08-08T16:52:24.495405+08:00           89 Query     SET NAMES utf8mb4
2018-08-08T16:52:24.495517+08:00           89 Query     select @@global.version
2018-08-08T16:52:24.495646+08:00           89 Query     select @@global.extra_port
2018-08-08T16:52:24.495743+08:00           89 Query     select @@global.port
2018-08-08T16:52:24.495848+08:00           89 Query     select @@global.hostname, @@global.port
基础信息检测

2018-08-08T16:52:24.495922+08:00           89 Query     show /* gh-ost */ grants for current_user()
查看gh-ost使用的用户权限

2018-08-08T16:52:24.496040+08:00           89 Query     select @@global.log_bin, @@global.binlog_format
2018-08-08T16:52:24.496122+08:00           89 Query     select @@global.binlog_row_image
检查binlog相关信息

2018-08-08T16:52:24.496235+08:00           89 Query     show /* gh-ost */ table status from `db1` like 't1'
检查t1表状态信息

2018-08-08T16:52:24.496734+08:00           89 Query     SELECT
                        SUM(REFERENCED_TABLE_NAME IS NOT NULL AND TABLE_SCHEMA='db1' AND TABLE_NAME='t1') as num_child_side_fk,
                        SUM(REFERENCED_TABLE_NAME IS NOT NULL AND REFERENCED_TABLE_SCHEMA='db1' AND REFERENCED_TABLE_NAME='t1') as num_parent_side_fk
                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                WHERE
                                REFERENCED_TABLE_NAME IS NOT NULL
                                AND ((TABLE_SCHEMA='db1' AND TABLE_NAME='t1')
                                        OR (REFERENCED_TABLE_SCHEMA='db1' AND REFERENCED_TABLE_NAME='t1')
                                )
检查t1表是否有外键

2018-08-08T16:52:24.504884+08:00           89 Query     SELECT COUNT(*) AS num_triggers
                        FROM INFORMATION_SCHEMA.TRIGGERS
                        WHERE
                                TRIGGER_SCHEMA='db1'
                                AND EVENT_OBJECT_TABLE='t1'
检查t1表是否有触发器

2018-08-08T16:52:24.505324+08:00           89 Query     explain select /* gh-ost */ * from `db1`.`t1` where 1=1
通过explain方式粗略统计表的行数

2018-08-08T16:52:24.505696+08:00           89 Query     SELECT
      COLUMNS.TABLE_SCHEMA,
      COLUMNS.TABLE_NAME,
      COLUMNS.COLUMN_NAME,
      UNIQUES.INDEX_NAME,
      UNIQUES.COLUMN_NAMES,
      UNIQUES.COUNT_COLUMN_IN_INDEX,
      COLUMNS.DATA_TYPE,
      COLUMNS.CHARACTER_SET_NAME,
                        LOCATE('auto_increment', EXTRA) > 0 as is_auto_increment,
      has_nullable
    FROM INFORMATION_SCHEMA.COLUMNS INNER JOIN (
      SELECT
        TABLE_SCHEMA,
        TABLE_NAME,
        INDEX_NAME,
        COUNT(*) AS COUNT_COLUMN_IN_INDEX,
        GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX ASC) AS COLUMN_NAMES,
        SUBSTRING_INDEX(GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX ASC), ',', 1) AS FIRST_COLUMN_NAME,
        SUM(NULLABLE='YES') > 0 AS has_nullable
      FROM INFORMATION_SCHEMA.STATISTICS
      WHERE
                                NON_UNIQUE=0
                                AND TABLE_SCHEMA = 'db1'
        AND TABLE_NAME = 't1'
      GROUP BY TABLE_SCHEMA, TABLE_NAME, INDEX_NAME
    ) AS UNIQUES
    ON (
      COLUMNS.TABLE_SCHEMA = UNIQUES.TABLE_SCHEMA AND
      COLUMNS.TABLE_NAME = UNIQUES.TABLE_NAME AND
      COLUMNS.COLUMN_NAME = UNIQUES.FIRST_COLUMN_NAME
    )
    WHERE
      COLUMNS.TABLE_SCHEMA = 'db1'
      AND COLUMNS.TABLE_NAME = 't1'
    ORDER BY
      COLUMNS.TABLE_SCHEMA, COLUMNS.TABLE_NAME,
      CASE UNIQUES.INDEX_NAME
        WHEN 'PRIMARY' THEN 0
        ELSE 1
      END,
      CASE has_nullable
        WHEN 0 THEN 0
        ELSE 1
      END,
      CASE IFNULL(CHARACTER_SET_NAME, '')
          WHEN '' THEN 0
          ELSE 1
      END,
      CASE DATA_TYPE
        WHEN 'tinyint' THEN 0
        WHEN 'smallint' THEN 1
        WHEN 'int' THEN 2
        WHEN 'bigint' THEN 3
        ELSE 100
      END,
      COUNT_COLUMN_IN_INDEX
获取db.t1表的PK、索引、是否为null等信息，以根据此信息进行采取数据范围
+--------------+------------+-------------+------------+--------------+-----------------------+-----------+--------------------+-------------------+--------------+
| TABLE_SCHEMA | TABLE_NAME | COLUMN_NAME | INDEX_NAME | COLUMN_NAMES | COUNT_COLUMN_IN_INDEX | DATA_TYPE | CHARACTER_SET_NAME | is_auto_increment | has_nullable |
+--------------+------------+-------------+------------+--------------+-----------------------+-----------+--------------------+-------------------+--------------+
| db1          | t1         | id          | PRIMARY    | id           |                     1 | int       | NULL               |                 1 |            0 |
+--------------+------------+-------------+------------+--------------+-----------------------+-----------+--------------------+-------------------+--------------+
1 row in set (0.00 sec)


2018-08-08T16:52:24.506538+08:00           89 Query     show columns from `db1`.`t1`
检查t1表的字段信息


2> 连接id=90:
2018-08-08T16:52:24.507092+08:00           90 Connect   sys@127.0.0.1 on information_schema using TCP/IP
通过tcp/ip方式连接到on information_schema库

2018-08-08T16:52:24.507197+08:00           90 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:24.507275+08:00           90 Query     SET autocommit=true
2018-08-08T16:52:24.507346+08:00           90 Query     SET NAMES utf8mb4
2018-08-08T16:52:24.507424+08:00           90 Query     show slave status
检查slave信息
2018-08-08T16:52:24.507591+08:00           90 Quit


3> 连接id=89:
2018-08-08T16:52:24.507658+08:00           89 Query     select @@global.log_slave_updates
2018-08-08T16:52:24.507768+08:00           89 Query     select @@global.version
2018-08-08T16:52:24.507860+08:00           89 Query     select @@global.extra_port
2018-08-08T16:52:24.507953+08:00           89 Query     select @@global.port
2018-08-08T16:52:24.508067+08:00           89 Query     show /* gh-ost readCurrentBinlogCoordinates */ master status
检查binlog信息


4> 连接id=91:
2018-08-08T16:52:24.508455+08:00           91 Connect   sys@127.0.0.1 on  using TCP/IP
2018-08-08T16:52:24.508562+08:00           91 Query     SHOW GLOBAL VARIABLES LIKE 'BINLOG_CHECKSUM'
2018-08-08T16:52:24.510672+08:00           91 Query     SET @master_binlog_checksum='NONE'
设置禁用binlog_checksum验证

2018-08-08T16:52:24.510818+08:00           91 Binlog Dump       Log: 'mysql-bin.000014'  Pos: 7360
slave接收binlog坐标

2018-08-08T16:52:24.511616+08:00           89 Query     select @@global.version
2018-08-08T16:52:24.511783+08:00           89 Query     select @@global.extra_port
2018-08-08T16:52:24.511865+08:00           89 Query     select @@global.port


5> 连接id=92:
2018-08-08T16:52:24.512146+08:00           92 Connect   sys@127.0.0.1 on db1 using TCP/IP
TCP方式连接到db1库

2018-08-08T16:52:24.512229+08:00           92 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:24.512283+08:00           92 Query     SET autocommit=true
2018-08-08T16:52:24.512347+08:00           92 Query     SET NAMES utf8mb4
2018-08-08T16:52:24.512410+08:00           92 Query     select @@global.version
2018-08-08T16:52:24.512497+08:00           92 Query     select @@global.extra_port
2018-08-08T16:52:24.512567+08:00           92 Query     select @@global.port
2018-08-08T16:52:24.512646+08:00           89 Query     select @@global.time_zone
2018-08-08T16:52:24.512753+08:00           89 Query     select @@global.hostname, @@global.port
2018-08-08T16:52:24.512832+08:00           89 Query     show columns from `db1`.`t1`
2018-08-08T16:52:24.513189+08:00           89 Query     show /* gh-ost */ table status from `db1` like '_t1_gho'
检查ghost表状态信息，即使不存在也不会报错

2018-08-08T16:52:24.513358+08:00           89 Query     show /* gh-ost */ table status from `db1` like '_t1_20180808165224_del'
检查将被重命名后的原表状态信息

2018-08-08T16:52:24.513552+08:00           89 Query     drop /* gh-ost */ table if exists `db1`.`_t1_ghc`
2018-08-08T16:52:24.517283+08:00           89 Query     create /* gh-ost */ table `db1`.`_t1_ghc` (
                        id bigint auto_increment,
                        last_update timestamp not null DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        hint varchar(64) charset ascii not null,
                        value varchar(4096) charset ascii not null,
                        primary key(id),
                        unique key hint_uidx(hint)
                ) auto_increment=256
删除并重建进度表

2018-08-08T16:52:24.535989+08:00           89 Query     create /* gh-ost */ table `db1`.`_t1_gho` like `db1`.`t1`
根据原表创建ghost表

2018-08-08T16:52:24.560381+08:00           89 Query     alter /* gh-ost */ table `db1`.`_t1_gho` modify c2 varchar(150) NOT NULL DEFAULT "xx"
修改ghost表为最终表结构

2018-08-08T16:52:24.596648+08:00           89 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(2, 0), 'state', 'GhostTableMigrated')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)

2018-08-08T16:52:24.600336+08:00           89 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'state at 1533718344600249998', 'GhostTableMigrated')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)

2018-08-08T16:52:24.604048+08:00           89 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:52:24.603911688+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
向进度表中写入几种状态信息

6> 连接id=93:
2018-08-08T16:52:24.604168+08:00           93 Connect   sys@127.0.0.1 on information_schema using TCP/IP
2018-08-08T16:52:24.604286+08:00           93 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:24.604423+08:00           93 Query     SET autocommit=true
2018-08-08T16:52:24.604528+08:00           93 Query     SET NAMES utf8mb4
2018-08-08T16:52:24.604620+08:00           93 Query     show slave status

7> 连接id=94:
2018-08-08T16:52:24.605015+08:00           94 Connect   sys@127.0.0.1 on db1 using TCP/IP
2018-08-08T16:52:24.605127+08:00           94 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:24.605239+08:00           94 Query     SET autocommit=true
2018-08-08T16:52:24.605333+08:00           94 Query     SET NAMES utf8mb4
2018-08-08T16:52:24.605621+08:00           94 Query     SELECT
      COLUMNS.TABLE_SCHEMA,
      COLUMNS.TABLE_NAME,
      COLUMNS.COLUMN_NAME,
      UNIQUES.INDEX_NAME,
      UNIQUES.COLUMN_NAMES,
      UNIQUES.COUNT_COLUMN_IN_INDEX,
      COLUMNS.DATA_TYPE,
      COLUMNS.CHARACTER_SET_NAME,
                        LOCATE('auto_increment', EXTRA) > 0 as is_auto_increment,
      has_nullable
    FROM INFORMATION_SCHEMA.COLUMNS INNER JOIN (
      SELECT
        TABLE_SCHEMA,
        TABLE_NAME,
        INDEX_NAME,
        COUNT(*) AS COUNT_COLUMN_IN_INDEX,
        GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX ASC) AS COLUMN_NAMES,
        SUBSTRING_INDEX(GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX ASC), ',', 1) AS FIRST_COLUMN_NAME,
        SUM(NULLABLE='YES') > 0 AS has_nullable
      FROM INFORMATION_SCHEMA.STATISTICS
      WHERE
                                NON_UNIQUE=0
                                AND TABLE_SCHEMA = 'db1'
        AND TABLE_NAME = '_t1_gho'
      GROUP BY TABLE_SCHEMA, TABLE_NAME, INDEX_NAME
    ) AS UNIQUES
    ON (
      COLUMNS.TABLE_SCHEMA = UNIQUES.TABLE_SCHEMA AND
      COLUMNS.TABLE_NAME = UNIQUES.TABLE_NAME AND
      COLUMNS.COLUMN_NAME = UNIQUES.FIRST_COLUMN_NAME
    )
    WHERE
      COLUMNS.TABLE_SCHEMA = 'db1'
      AND COLUMNS.TABLE_NAME = '_t1_gho'
    ORDER BY
      COLUMNS.TABLE_SCHEMA, COLUMNS.TABLE_NAME,
      CASE UNIQUES.INDEX_NAME
        WHEN 'PRIMARY' THEN 0
        ELSE 1
      END,
      CASE has_nullable
        WHEN 0 THEN 0
        ELSE 1
      END,
      CASE IFNULL(CHARACTER_SET_NAME, '')
          WHEN '' THEN 0
          ELSE 1
      END,
      CASE DATA_TYPE
        WHEN 'tinyint' THEN 0
        WHEN 'smallint' THEN 1
        WHEN 'int' THEN 2
        WHEN 'bigint' THEN 3
        ELSE 100
      END,
      COUNT_COLUMN_IN_INDEX
获取db._t1_gho表的PK、索引、是否为null等信息，以根据此信息进行采取数据范围
+--------------+------------+-------------+------------+--------------+-----------------------+-----------+--------------------+-------------------+--------------+
| TABLE_SCHEMA | TABLE_NAME | COLUMN_NAME | INDEX_NAME | COLUMN_NAMES | COUNT_COLUMN_IN_INDEX | DATA_TYPE | CHARACTER_SET_NAME | is_auto_increment | has_nullable |
+--------------+------------+-------------+------------+--------------+-----------------------+-----------+--------------------+-------------------+--------------+
| db1          | _t1_gho    | id          | PRIMARY    | id           |                     1 | int       | NULL               |                 1 |            0 |
+--------------+------------+-------------+------------+--------------+-----------------------+-----------+--------------------+-------------------+--------------+
1 row in set (0.00 sec)

2018-08-08T16:52:24.608149+08:00           94 Query     show columns from `db1`.`_t1_gho`
获取_t1_gho表字段信息

2018-08-08T16:52:24.608609+08:00           94 Query     select
                                *
                        from
                                information_schema.columns
                        where
                                table_schema='db1'
                                and table_name='t1'


2018-08-08T16:52:24.609255+08:00           94 Query     select
                                *
                        from
                                information_schema.columns
                        where
                                table_schema='db1'
                                and table_name='t1'
获取t1表列的所有信息

8> 连接id=89:
2018-08-08T16:52:24.609758+08:00           89 Query     select
                                *
                        from
                                information_schema.columns
                        where
                                table_schema='db1'
                                and table_name='t1'
获取t1表列的所有信息

9> 连接id=94:
2018-08-08T16:52:24.610172+08:00           94 Query     select
                                *
                        from
                                information_schema.columns
                        where
                                table_schema='db1'
                                and table_name='_t1_gho'
获取_t1_gho表列的所有信息

2018-08-08T16:52:24.610812+08:00           94 Query     select /* gh-ost */ count(*) as rows from `db1`.`t1`
获取t1表某时刻真实的行数

10> 连接id=89:
2018-08-08T16:52:24.610968+08:00           89 Query     select /* gh-ost `db1`.`t1` */ `id`
                                from
                                        `db1`.`t1`
                                order by
                                        `id` asc
                                limit 1
获取t1表pk id 最小值
SQL> select /* gh-ost `db1`.`t1` */ `id`
    -> from
    -> `db1`.`t1`
    -> order by
    -> `id` asc
    -> limit 1;
+----+
| id |
+----+
| 90011 |
+----+
1 row in set (0.00 sec)

SQL> select min(id) from t1;   
+---------+
| min(id) |
+---------+
|      90011 |
+---------+
1 row in set (0.00 sec)

2018-08-08T16:52:24.611142+08:00           89 Query     select /* gh-ost `db1`.`t1` */ `id`
                                from
                                        `db1`.`t1`
                                order by
                                        `id` desc
                                limit 1
获取t1表pk id 最大值
SQL> select /* gh-ost `db1`.`t1` */ `id`
    -> from
    -> `db1`.`t1`
    -> order by
    -> `id` desc
    -> limit 1
    -> ;
+------------+
| id         |
+------------+
| 13303956 |
+------------+
1 row in set (0.00 sec)

SQL> select max(id) from t1;
+------------+
| max(id)    |
+------------+
| 13303956 |
+------------+
1 row in set (0.00 sec)


2018-08-08T16:52:24.611485+08:00           89 Query     show global status like 'Threads_running'
获取未休眠的线程数

11> 连接id=95:
2018-08-08T16:52:24.613431+08:00           95 Connect   sys@127.0.0.1 on db1 using TCP/IP
连接到db1库

2018-08-08T16:52:24.613451+08:00           89 Query     show global status like 'threads_connected'
当前打开的连接数

2018-08-08T16:52:24.614565+08:00           95 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:24.614683+08:00           95 Query     SET autocommit=true
2018-08-08T16:52:24.614772+08:00           95 Query     SET NAMES utf8mb4
2018-08-08T16:52:24.614874+08:00           95 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
获取进度表的心跳信息

2018-08-08T16:52:24.615115+08:00           89 Query     show global status like 'Threads_running'
2018-08-08T16:52:24.616507+08:00           95 Query     show global status like 'threads_connected'
2018-08-08T16:52:24.618552+08:00           89 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'copy iteration 0 at 1533718344', 'Copy: 0/9684915 0.0%; Applied: 0; Backlog: 0/1000; Time: 0s(total), 0s(copy); streamer: mysql-bin.000014:9989; State: migrating; ETA: N/A')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
向进度表中写入row-copy迭代信息

2018-08-08T16:52:24.709994+08:00           95 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:52:24.709742486+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)

2018-08-08T16:52:24.715544+08:00           89 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
2018-08-08T16:52:24.809953+08:00           95 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:52:24.809765425+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
查询/写入心跳信息到进度表



2018-08-08T16:52:25.515392+08:00           95 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
2018-08-08T16:52:25.610057+08:00           89 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:52:25.609858928+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
查询/写入心跳信息到进度表

2018-08-08T16:52:25.615330+08:00           95 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
2018-08-08T16:52:25.618459+08:00           89 Query     show global status like 'Threads_running'

从下面可以看出gh-ost是如何以一定频率进行row-copy:
2018-08-08T16:52:25.618503+08:00           95 Query     select  /* gh-ost `db1`.`t1` iteration:0 */ -- 第一次迭代
                                                `id`
                                        from
                                                `db1`.`t1`
                                        where ((`id` > _binary'90011') or ((`id` = _binary'90011'))) and ((`id` < _binary'13303956') or ((`id` = _binary'13303956')))
                                        order by
                                                `id` asc
                                        limit 1
                                        offset 1999

根据前面获取t1表PK的最大值和最小值范围，及通过limit特性，获取每次row-copy的结束PK id，如每2000行1次
上面SQL简化：
SQL> SELECT 
    ->     id
    -> FROM
    ->     db1.t1
    -> WHERE
    ->     (id >= _BINARY'90011') AND (id <= _BINARY'13303956')
    -> ORDER BY id ASC
    -> LIMIT 1 OFFSET 1999;
+-------+
| id    |
+-------+
| 92010 |
+-------+
1 row in set (0.00 sec)

SQL> select min(id) from t1;
+------------+
| max(id)    |
+------------+
|  90011     |
+------------+
1 row in set (0.00 sec)

SQL> select max(id) from t1;
+------------+
| max(id)    |
+------------+
| 13303956 |
+------------+
1 row in set (0.00 sec)

2018-08-08T16:52:25.620476+08:00           89 Query     show global status like 'threads_connected'
2018-08-08T16:52:25.622270+08:00           89 Query     show global status like 'Threads_running'

新开一个连接id=96
2018-08-08T16:52:25.623572+08:00           96 Connect   sys@127.0.0.1 on db1 using TCP/IP
2018-08-08T16:52:25.623572+08:00           89 Query     show global status like 'threads_connected'
2018-08-08T16:52:25.623710+08:00           96 Query     SELECT @@max_allowed_packet
2018-08-08T16:52:25.623807+08:00           96 Query     SET NAMES utf8mb4
2018-08-08T16:52:25.623875+08:00           96 Query     SET autocommit=true

2018-08-08T16:52:25.623986+08:00           96 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'copy iteration 0 at 1533718345', 'Copy: 0/9684915 0.0%; Applied: 0; Backlog: 0/1000; Time: 1s(total), 1s(copy); streamer: mysql-bin.000014:16826; State: migrating; ETA: N/A')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
将row-copy迭代信息写入到进度表

2018-08-08T16:52:25.687171+08:00           95 Quit

2018-08-08T16:52:25.687263+08:00           89 Query     START TRANSACTION
==================================================================== 开启一个事务 ====================================================================

2018-08-08T16:52:25.687526+08:00           89 Query     SET
                        SESSION time_zone = 'SYSTEM',
                        sql_mode = CONCAT(@@session.sql_mode, ',STRICT_ALL_TABLES')
设置时区和sql_mode

2018-08-08T16:52:25.687725+08:00           89 Query     insert /* gh-ost `db1`.`t1` */ ignore into `db1`.`_t1_gho` (`id`, `name`, `c1`, `c2`, `c30`, `c3`)
      (select `id`, `name`, `c1`, `c2`, `c30`, `c3` from `db1`.`t1` force index (`PRIMARY`)
        where (((`id` > _binary'90011') or ((`id` = _binary'90011'))) and ((`id` < _binary'92010') or ((`id` = _binary'92010')))) lock in share mode
      )
1> 根据上面获取的每次row-copy的结束PK ID，采用insert ignore into、指定列、强制走PK索引、where 起点 - 终点 lock in share mode 方式进行row-copy
SQL> select min(id) from _t1_gho;    
+---------+
| min(id) |
+---------+
|   90011 |
+---------+
1 row in set (0.00 sec)

SQL> select * from _t1_gho order by id asc limit 1 offset 1999;
+-------+------+---------------------+----+-----+----+
| id    | name | c1                  | c2 | c30 | c3 |
+-------+------+---------------------+----+-----+----+
| 92010 | abc1 | 1970-01-01 00:00:00 | xx | xx  | xx |
+-------+------+---------------------+----+-----+----+
1 row in set (0.00 sec)

2> insert ignore into
如果使用IGNORE修饰符，则会忽略执行INSERT语句时发生的错误。
例如，如果没有IGNORE，则复制表中现有UNIQUE索引或PRIMARY KEY值的行会导致重复键错误，并且语句将中止。
使用IGNORE，该行将被丢弃并且不会发生错误。忽略的错误会生成警告。
如果没有IGNORE，则会中止此类INSERT语句并显示错误。使用INSERT IGNORE时，对于包含不匹配值的行，插入操作将无提示失败，但会插入匹配的行。
如果未指定IGNORE，则会触发错误的数据转换会中止语句。使用IGNORE，将无效值调整为最接近的值并插入;产生警告，但声明不会中止。
https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#ignore-strict-comparison

3> _binary
转换函数和运算符可以将值从一种数据类型转换为另一种数据类型。
将字符串转换为二进制字符串
BINARY运算符将表达式转换为二进制字符串,BINARY的一个常见用途是强制逐字节而不是逐字符地进行字符串比较，实际上变为区分大小写。
BINARY运算符还会导致比较中的尾随空格很重要。
相比之下，BINARY影响整个操作;它可以在任一操作数之前给出，但结果相同。
为了将字符串表达式转换为二进制字符串，这些结构是等效的：
BINARY expr
CAST(expr AS BINARY)
CONVERT(expr USING BINARY)

如果值是字符串文字，则可以将其指定为二进制字符串，而不使用_binary字符集导入器执行任何转换：
SQL> select 'A' = 'a';
+-----------+
| 'A' = 'a' |
+-----------+
|         1 |
+-----------+
1 row in set (0.00 sec)

SQL> select 'A' = _binary'a';
+------------------+
| 'A' = _binary'a' |
+------------------+
|                0 |
+------------------+
1 row in set (0.00 sec)

SQL> select 'A' = _binary'A';
+------------------+
| 'A' = _binary'A' |
+------------------+
|                1 |
+------------------+
1 row in set (0.00 sec)

https://dev.mysql.com/doc/refman/5.7/en/cast-functions.html

4> lock in share mode
1> 在读取的任何行上设置共享模式锁定。其他会话可以读取行，但在事务提交之前无法修改它们
      锁定读的行,没有被其它事务先占领
2> 如果这些行中的任何行已被另一个尚未提交的事务更改，则查询将等待该事务结束，然后使用最新值。
      锁定读的行,被其它事务先占领


2018-08-08T16:52:25.709871+08:00           96 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:52:25.709760123+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
向进度表中插入心跳信息

2018-08-08T16:52:25.715273+08:00           96 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
+-----------+-------------------------------------+
| hint      | value                               |
+-----------+-------------------------------------+
| heartbeat | 2018-08-08T13:49:32.432568699+08:00 |
+-----------+-------------------------------------+
1 row in set (0.00 sec)

2018-08-08T16:52:25.723880+08:00           89 Query     COMMIT
==================================================================== 提交事务 ====================================================================


2018-08-08T16:52:25.728714+08:00           96 Query     select  /* gh-ost `db1`.`t1` iteration:1 */  -- 第2次迭代
                                                `id`
                                        from
                                                `db1`.`t1`
                                        where ((`id` > _binary'92010')) and ((`id` < _binary'13303956') or ((`id` = _binary'13303956')))
                                        order by
                                                `id` asc
                                        limit 1
                                        offset 1999
基于上次获取的迭代结束点,查询本次迭代结束点
上次是大于等于,本次是大于,不包含等于
+-------+
| id    |
+-------+
| 94010 |
+-------+
获取到每次迭代结束点后开启一个事务

2018-08-08T16:52:25.745130+08:00           89 Query     START TRANSACTION
==================================================================== 开始事务 ====================================================================

2018-08-08T16:52:25.745262+08:00           89 Query     SET
                        SESSION time_zone = 'SYSTEM',
                        sql_mode = CONCAT(@@session.sql_mode, ',STRICT_ALL_TABLES')
设置时区和sql_mode

2018-08-08T16:52:25.745465+08:00           89 Query     insert /* gh-ost `db1`.`t1` */ ignore into `db1`.`_t1_gho` (`id`, `name`, `c1`, `c2`, `c30`, `c3`)
      (select `id`, `name`, `c1`, `c2`, `c30`, `c3` from `db1`.`t1` force index (`PRIMARY`)
        where (((`id` > _binary'92010')) and ((`id` < _binary'94010') or ((`id` = _binary'94010')))) lock in share mode
      )
向ghost表中拷贝数据

2018-08-08T16:52:25.780914+08:00           89 Query     COMMIT
==================================================================== 提交事务 ====================================================================

2018-08-08T16:52:25.785954+08:00           96 Query     select  /* gh-ost `db1`.`t1` iteration:2 */  -- 第3次迭代
                                                `id`
                                        from
                                                `db1`.`t1`
                                        where ((`id` > _binary'94010')) and ((`id` < _binary'13303956') or ((`id` = _binary'13303956')))
                                        order by
                                                `id` asc
                                        limit 1
                                        offset 1999
基于上次获取的迭代结束点,查询本次迭代结束点
上次是大于等于,本次是大于,不包含等于
+-------+
| id    |
+-------+
| 96010 |
+-------+

2018-08-08T16:52:25.806753+08:00           89 Query     START TRANSACTION
==================================================================== 开始事务 ====================================================================

2018-08-08T16:52:25.806879+08:00           89 Query     SET
                        SESSION time_zone = 'SYSTEM',
                        sql_mode = CONCAT(@@session.sql_mode, ',STRICT_ALL_TABLES')

2018-08-08T16:52:25.807031+08:00           89 Query     insert /* gh-ost `db1`.`t1` */ ignore into `db1`.`_t1_gho` (`id`, `name`, `c1`, `c2`, `c30`, `c3`)
      (select `id`, `name`, `c1`, `c2`, `c30`, `c3` from `db1`.`t1` force index (`PRIMARY`)
        where (((`id` > _binary'94010')) and ((`id` < _binary'96010') or ((`id` = _binary'96010')))) lock in share mode
      )
          
2018-08-08T16:52:25.809823+08:00           96 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:52:25.809732839+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)

2018-08-08T16:52:25.815247+08:00           96 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255


2018-08-08T16:52:25.845222+08:00           89 Query     COMMIT
==================================================================== 提交事务 ====================================================================

从上面迭代可以看出gh-ost开启了其中2个连接：
id=96连接：用于获取每次迭代结束点、向进度表中写入心跳信息
id=89连接：用于设置时区和sql_mode、row-copy数据



2018-08-08T16:52:33.618382+08:00          115 Query     show global status like 'Threads_running'
2018-08-08T16:52:33.620062+08:00          115 Query     show global status like 'threads_connected'
2018-08-08T16:52:33.621361+08:00          115 Query     show global status like 'threads_connected'
2018-08-08T16:52:33.622513+08:00          115 Query     show global status like 'Threads_running'




2018-08-08T16:52:44.623696+08:00          179 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'copy iteration 472 at 1533718364', 'Copy: 944000/10354930 9.1%; Applied: 0; Backlog: 0/1000; Time: 20s(total), 20s(copy); streamer: mysql-bin.000014:24082835; State: migrating; ETA: 3m19s')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)



2018-08-08T16:52:48.623753+08:00          203 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'copy iteration 612 at 1533718368', 'Copy: 1224000/10354930 11.8%; Applied: 0; Backlog: 0/1000; Time: 24s(total), 24s(copy); streamer: mysql-bin.000014:30374480; State: migrating; ETA: 2m59s')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
			
			
2018-08-08T16:55:04.787569+08:00	 1157 Query	insert /* gh-ost */ into `db1`.`_t1_ghc`
				(id, hint, value)
			values
				(NULLIF(0, 0), 'copy iteration 5178 at 1533718504', 'Copy: 10354930/10354930 100.0%; Applied: 2; Backlog: 0/1000; Time: 2m40s(total), 2m40s(copy); streamer: mysql-bin.000015:28654886; State: migrating; ETA: due')
			on duplicate key update
				last_update=NOW(),
				value=VALUES(value)
上面是一些进度信息,100.0%表示row-copy完成


2018-08-08T16:56:56.793124+08:00	   81 Query	select thread_os_id from performance_schema.threads where thread_id=ps_thread_id(connection_id())
获取当前连接的线程id=81


get_lock()           获取命名锁
RELEASE_ALL_LOCKS()	 释放所有当前命名的锁
RELEASE_LOCK()	     释放命名锁
IS_USED_LOCK()       命名锁是否正在使用;返回连接标识符，如果为true
https://dev.mysql.com/doc/refman/5.7/en/miscellaneous-functions.html#function_get-lock
https://dev.mysql.com/doc/refman/5.7/en/miscellaneous-functions.html#function_release-all-locks
https://dev.mysql.com/doc/refman/5.7/en/miscellaneous-functions.html#function_release-lock

session1：
SQL> select get_lock('gh-ost.1157.lock', 0);
+---------------------------------+
| get_lock('gh-ost.1157.lock', 0) |
+---------------------------------+
|                               1 |
+---------------------------------+
1 row in set (0.00 sec)

SQL> select connection_id();
+-----------------+
| connection_id() |
+-----------------+
|             417 |
+-----------------+
1 row in set (0.00 sec)


session2：
SQL> select get_lock('gh-ost.1157.lock', 0);
+---------------------------------+
| get_lock('gh-ost.1157.lock', 0) |
+---------------------------------+
|                               0 |
+---------------------------------+
1 row in set (0.00 sec)


SQL>  select is_used_lock('gh-ost.1157.lock');
+----------------------------------+
| is_used_lock('gh-ost.1157.lock') |
+----------------------------------+
|                              417 |
+----------------------------------+
1 row in set (0.00 sec)


2018-08-08T16:58:34.872238+08:00         1157 Query     START TRANSACTION
开始一个事务

2018-08-08T16:58:34.872535+08:00         1157 Query     select connection_id()
获取当前连接id 1157

2018-08-08T16:58:34.872770+08:00         1157 Query     select get_lock('gh-ost.1157.lock', 0)

2018-08-08T16:58:34.872931+08:00         1157 Query     set session lock_wait_timeout:=6
此变量指定尝试获取元数据锁的超时（以秒为单位）。允许值范围为1到31536000（1年）。默认值为31536000。


设置锁超时时间

2018-08-08T16:58:34.873072+08:00         1161 Query     show /* gh-ost */ table status from `db1` like '_t1_20180808165224_del'
2018-08-08T16:58:34.873412+08:00         1161 Query     create /* gh-ost */ table `db1`.`_t1_20180808165224_del` (
                        id int auto_increment primary key
                ) engine=InnoDB comment='ghost-cut-over-sentry'



2018-08-08T16:58:34.910171+08:00         1162 Connect   sys@127.0.0.1 on db1 using TCP/IP
2018-08-08T16:58:34.910317+08:00         1162 Query     SELECT @@max_allowed_packet
2018-08-08T16:58:34.910432+08:00         1162 Query     SET autocommit=true
2018-08-08T16:58:34.910531+08:00         1162 Query     SET NAMES utf8mb4
2018-08-08T16:58:34.910663+08:00         1162 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:58:34.909724442+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
2018-08-08T16:58:34.915311+08:00         1162 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255


2018-08-08T16:58:34.984458+08:00         1157 Query     lock /* gh-ost */ tables `db1`.`t1` write, `db1`.`_t1_20180808165224_del` write


2018-08-08T16:58:34.984931+08:00         1162 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(2, 0), 'state', 'AllEventsUpToLockProcessed:1533718714984839844')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)


2018-08-08T16:58:34.989594+08:00         1161 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'state at 1533718714989494455', 'AllEventsUpToLockProcessed:1533718714984839844')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)


2018-08-08T16:58:35.715472+08:00         1162 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
2018-08-08T16:58:35.809993+08:00         1161 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:58:35.809769214+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
2018-08-08T16:58:35.815323+08:00         1162 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255



2018-08-08T16:58:35.829865+08:00         1161 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(0, 0), 'copy iteration 5178 at 1533718715', 'Copy: 10354930/10354930 100.0%; Applied: 3; Backlog: 0/1000; Time: 6m11s(total), 2m40s(copy); streamer: mysql-bin.000015:29953244; State: migrating; ETA: due')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)


2018-08-08T16:58:35.834464+08:00         1162 Query     START TRANSACTION
2018-08-08T16:58:35.834612+08:00         1162 Query     select connection_id()
2018-08-08T16:58:35.834827+08:00         1161 Query     select id
                        from information_schema.processlist
                        where
                                id != connection_id()
                                and 1162 in (0, id)
                                and state like concat('%', 'metadata lock', '%')
                                and info  like concat('%', 'rename', '%')



2018-08-08T16:58:35.835036+08:00         1162 Query     set session lock_wait_timeout:=3

2018-08-08T16:58:35.835193+08:00         1162 Query     rename /* gh-ost */ table `db1`.`t1` to `db1`.`_t1_20180808165224_del`, `db1`.`_t1_gho` to `db1`.`t1`

2018-08-08T16:58:35.836852+08:00         1161 Query     select is_used_lock('gh-ost.1157.lock')

2018-08-08T16:58:35.837058+08:00         1157 Query     drop /* gh-ost */ table if exists `db1`.`_t1_20180808165224_del`

2018-08-08T16:58:35.872062+08:00         1157 Query     unlock tables

2018-08-08T16:58:35.872940+08:00         1157 Query     ROLLBACK



2018-08-08T16:58:35.909924+08:00         1161 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:58:35.909785245+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)
2018-08-08T16:58:35.915334+08:00         1157 Query     select hint, value from `db1`.`_t1_ghc` where hint = 'heartbeat' and id <= 255
2018-08-08T16:58:35.932089+08:00         1162 Query     ROLLBACK


2018-08-08T16:58:35.932111+08:00         1157 Query     show /* gh-ost */ table status from `db1` like '_t1_20180808165224_del'
2018-08-08T16:58:35.932626+08:00         1157 Quit



2018-08-08T16:58:36.009939+08:00         1161 Query     insert /* gh-ost */ into `db1`.`_t1_ghc`
                                (id, hint, value)
                        values
                                (NULLIF(1, 0), 'heartbeat', '2018-08-08T16:58:36.009797175+08:00')
                        on duplicate key update
                                last_update=NOW(),
                                value=VALUES(value)


2018-08-08T16:58:36.014285+08:00         1162 Query     drop /* gh-ost */ table if exists `db1`.`_t1_ghc`


2018-08-08T16:58:36.025198+08:00         1161 Quit
2018-08-08T16:58:36.025211+08:00         1162 Quit
2018-08-08T16:58:36.025249+08:00           93 Quit
2018-08-08T16:58:36.025449+08:00           92 Quit
