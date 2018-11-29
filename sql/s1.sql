1> 原始SQL && 执行计划
SELECT
    u.id,
    u.username,
    u.real_name,
    u.mobile_phone,
    u.last_login_ip AS ip,
    u.device_id
FROM
    t1 u
        LEFT JOIN
    t2 c ON u.id = c.user_id
WHERE
    (u.real_name = 'xxx'
        OR u.mobile_phone = 'xxx'
        OR u.last_login_ip = 'xxx'
        OR c.card_num = 'xxx')
        AND (u.id NOT IN (SELECT
            user_id
        FROM
            t3
        WHERE
            relate_user_id = '1000'))

SQL> desc
    -> SELECT
    ->    u.id,
    ->    u.username,
    ->    u.real_name,
    ->    u.mobile_phone,
    ->    u.last_login_ip AS ip,
    ->    u.device_id
    -> FROM
    ->    t1 u
    ->        LEFT JOIN
    ->    t2 c ON u.id = c.user_id
    -> WHERE
    ->    (u.real_name = 'xxx'
    ->        OR u.mobile_phone = 'xxx'
    ->        OR u.last_login_ip = 'xxx'
    ->        OR c.card_num = 'xxx')
    ->        AND (u.id NOT IN (SELECT
    ->            user_id
    ->        FROM
    ->            t3
    ->        WHERE
    ->            relate_user_id = '1000'));
+----+-------------+------------------------+------------+------+--------------------------------------------+-------+---------+------------+--------+----------+--------------------------+
| id | select_type | table                  | partitions | type | possible_keys                              | key  | key_len | ref        | rows  | filtered | Extra                    |
+----+-------------+------------------------+------------+------+--------------------------------------------+-------+---------+------------+--------+----------+--------------------------+
|  1 | PRIMARY    | u                      | NULL      | ALL  | i_last_login_ip,i_real_name,i_mobile_phone | NULL  | NULL    | NULL      | 546928 |  100.00 | Using where              |
|  1 | PRIMARY    | c                      | NULL      | ref  | i_aaa                                      | i_aaa | 5      | db1.u.id |      1 |  100.00 | Using where; Using index |
|  2 | SUBQUERY   | t3                     | NULL      | ref  | i_user_id_group_id,i_aaa                   | i_aaa | 5      | const      |      1 |  100.00 | NULL                     |
+----+-------------+------------------------+------------+------+--------------------------------------------+-------+---------+------------+--------+----------+--------------------------+
3 rows in set, 1 warning (0.00 sec)


SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
  Code: 1003
Message: /* select#1 */ select db1.u.id AS id,db1.u.username AS username,db1.u.real_name AS real_name,db1.u.mobile_phone AS mobile_phone,db1.u.last_login_ip AS ip,db1.u.device_id AS device_id from db1.t1 u left join db1.t2 c on((db1.c.user_id = db1.u.id)) where (((db1.u.real_name = 'xxx') or (db1.u.mobile_phone = 'xxx') or (db1.u.last_login_ip = 'xxx') or (db1.c.card_num = 'xxx')) and (not(<in_optimizer>(db1.u.id,db1.u.id in ( <materialize> (/* select#2 */ select db1.t3.user_id from db1.t3 where (db1.t3.relate_user_id = '1000') ), <primary_index_lookup>(db1.u.id in <temporary table> on <auto_key> where ((db1.u.id = materialized-subquery.user_id))))))))
1 row in set (0.00 sec)

现象：
     where后条件列都有索引，u表因为是或者逻辑，所以每列都建立索引，但是如上显示u表不走索引，why?
	 一开始以为是小括号()太多导致，去除一些不必要的小括号，依然不行，
	 再尝试将OR c.card_num = 'xxx'注释掉，发现SQL结果秒出，原因出在这里，可为什么多加一个条件会导致不走索引？
	 此sql运行很频繁，每次都要扫描50w行+，每次运行时间为2s左右，cpu负载一直为200+
	 
原因：
     网上说的原因大多为OR条件太多或存在or条件会导致不走索引

思路：
     根据条件分别查出u、c表的结果，通过union合并

	 
2> 查询不包含c表的数据，c.card_num = 'xxx'：
SQL> SELECT
    ->    u.id,
    ->    u.username,
    ->    u.real_name,
    ->    u.mobile_phone,
    ->    u.last_login_ip AS ip,
    ->    u.device_id
    -> FROM
    ->    t1 u
    -> WHERE
    ->    ((u.real_name = 'xxx')
    ->        OR (u.mobile_phone = 'xxx')
    ->        OR (u.last_login_ip = 'xxx'))
    ->        AND (u.id NOT IN (SELECT
    ->            user_id
    ->        FROM
    ->            t3
    ->        WHERE
    ->            relate_user_id = '1000'));
+------------+----------+-----------+------------------+----------------+-----------+
| id        | username | real_name | mobile_phone    | ip            | device_id |
+------------+----------+-----------+------------------+----------------+-----------+
| 1000      | xxx      | xxx       | xxx             | xxx           |           |
+------------+----------+-----------+------------------+----------------+-----------+
1 row in set (0.00 sec)


3> 查询c表的数据
SQL> SELECT
    ->    u.*
    -> FROM
    ->    (SELECT
    ->        u.id,
    ->            u.username,
    ->            u.real_name,
    ->            u.mobile_phone,
    ->            u.last_login_ip AS ip,
    ->            u.device_id
    ->    FROM
    ->        t1 u
    ->    WHERE
    ->        ((u.real_name = 'xxx')
    ->            OR (u.mobile_phone = 'xxx')
    ->            OR (u.last_login_ip = 'xxx'))
    ->            AND (u.id NOT IN (SELECT
    ->                user_id
    ->            FROM
    ->                t3
    ->            WHERE
    ->                relate_user_id = '1000'))) u
    ->        LEFT JOIN
    ->    t2 c ON u.id = c.user_id
    -> WHERE
    ->    c.card_num = 'xxx';
+------------+----------+-----------+------------------+----------------+-----------+
| id        | username | real_name | mobile_phone    | ip            | device_id |
+------------+----------+-----------+------------------+----------------+-----------+
| 1000      | xxx      | xxx       | xxx             | xxx           |           |
+------------+----------+-----------+------------------+----------------+-----------+
1 row in set (0.00 sec)


4> 合并它们的结果：
SELECT
    u.id,
    u.username,
    u.real_name,
    u.mobile_phone,
    u.last_login_ip AS ip,
    u.device_id
FROM
    t1 u
WHERE
    ((u.real_name = 'xxx')
        OR (u.mobile_phone = 'xxx')
        OR (u.last_login_ip = 'xxx'))
        AND (u.id NOT IN (SELECT
            user_id
        FROM
            t3
        WHERE
            relate_user_id = '1000'))

UNION

SELECT
    u.*
FROM
    (SELECT
        u.id,
            u.username,
            u.real_name,
            u.mobile_phone,
            u.last_login_ip AS ip,
            u.device_id
    FROM
        t1 u
    WHERE
        ((u.real_name = 'xxx')
            OR (u.mobile_phone = 'xxx')
            OR (u.last_login_ip = 'xxx'))
            AND (u.id NOT IN (SELECT
                user_id
            FROM
                t3
            WHERE
                relate_user_id = '1000'))) u
        LEFT JOIN
    t2 c ON u.id = c.user_id
WHERE
    c.card_num = 'xxx'
+------------+----------+-----------+------------------+----------------+-----------+
| id        | username | real_name | mobile_phone    | ip            | device_id |
+------------+----------+-----------+------------------+----------------+-----------+
| 1000      | xxx      | xxx       | xxx             | xxx           |           |
+------------+----------+-----------+------------------+----------------+-----------+
1 row in set (0.01 sec)


+----+--------------------+------------------------+------------+-------------+----------------------------------------------------+--------------------------------------------+------------+-----------------+------+----------+----------------------------------------------------------------------+
| id | select_type        | table                  | partitions | type        | possible_keys                                      | key                                        | key_len    | ref             | rows | filtered | Extra                                                                |
+----+--------------------+------------------------+------------+-------------+----------------------------------------------------+--------------------------------------------+------------+-----------------+------+----------+----------------------------------------------------------------------+
|  1 | PRIMARY     | u       | NULL       | index_merge | i_last_login_ip,i_real_name,i_mobile_phone    | i_real_name,i_mobile_phone,i_last_login_ip | 203,203,61 | NULL   |    3 |   100.00 | Using union(i_real_name,i_mobile_phone,i_last_login_ip); Using where |
|  2 | DEPENDENT SUBQUERY | t3 | NULL       | ref         | i_user_id_group_id,i_aaa                           | i_aaa                   | 5          | const              |    1 |    10.00 | Using where                                                          |
|  3 | UNION              | c           | NULL            | ref         | i_bbb,i_aaa           | i_bbb                 | 403            | const           |    1 |   100.00 | Using where; Using index                                             |
|  3 | UNION              | u             | NULL          | eq_ref      | PRIMARY,i_last_login_ip,i_real_name,i_mobile_phone | PRIMARY     | 4          | db1.c.user_id |    1 |    27.10 | Using where                                                          |
|  5 | DEPENDENT SUBQUERY | t3 | NULL       | ref         | i_user_id_group_id,i_aaa                           | i_aaa         | 5          | const                   |    1 |    10.00 | Using where                                                          |
| NULL | UNION RESULT     | <union1,3>             | NULL       | ALL         | NULL      | NULL                                  | NULL       | NULL            | NULL |     NULL | Using temporary                                                      |
+----+--------------------+------------------------+------------+-------------+----------------------------------------------------+--------------------------------------------+------------+-----------------+------+----------+----------------------------------------------------------------------+
6 rows in set, 1 warning (0.00 sec)



