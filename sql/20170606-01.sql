
-- 对表做完分区后，方法二比方法一快：
-- 方法一：
explain extended 
SELECT 
    a.lip, a.count
FROM
    (SELECT 
        T1.lip, COUNT(T1.lip) AS count
    FROM
        t_log T1
    WHERE
        T1.cid = '200475639'
            AND T1.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
            AND T1.isw = 0
            AND T1.pid = 'xxx'
            AND T1.cll NOT IN (0)
            AND T1.cte >= 1
    GROUP BY T1.lip) a
WHERE
    a.lip IN (SELECT 
            T2.lip
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx');
+----+-------------+------------+-------+---------------------------------------------------+-------------------------------+---------+------------------+------+----------+----------------------------------------------+
| id | select_type | table      | type  | possible_keys                                     | key                           | key_len | ref              | rows | filtered | Extra                                        |
+----+-------------+------------+-------+---------------------------------------------------+-------------------------------+---------+------------------+------+----------+----------------------------------------------+
|  1 | PRIMARY     | <derived2> | ALL   | NULL                                              | NULL                          | NULL    | NULL             |  489 |   100.00 | Using where                                  |
|  1 | PRIMARY     | T2         | ref   | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | i_ip_id_level_type_white_time | 195     | a.lip,const |    5 |   100.00 | Using where; FirstMatch(<derived2>)          |
|  2 | DERIVED     | T1         | range | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | idx2                          | 29      | NULL             |  489 |   100.00 | Using where; Using temporary; Using filesort |
+----+-------------+------------+-------+---------------------------------------------------+-------------------------------+---------+------------------+------+----------+----------------------------------------------+
3 rows in set, 1 warning (0.00 sec)



-- 方法二：
explain extended
SELECT 
    a.lip, a.count
FROM
    (SELECT 
        T1.lip, COUNT(T1.lip) AS count
    FROM
        t_log T1
    WHERE
        T1.cid = '200475639'
            AND T1.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
            AND T1.isw = 0
            AND T1.pid = 'xxx'
            AND T1.cll NOT IN (0)
            AND T1.cte >= 1
    GROUP BY T1.lip) a
WHERE
    EXISTS( SELECT 
            1
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx'
                AND T2.lip = a.lip);
+----+--------------------+------------+-------+---------------------------------------------------+-------------------------------+---------+------------------+------+----------+----------------------------------------------+
| id | select_type        | table      | type  | possible_keys                                     | key                           | key_len | ref              | rows | filtered | Extra                                        |
+----+--------------------+------------+-------+---------------------------------------------------+-------------------------------+---------+------------------+------+----------+----------------------------------------------+
|  1 | PRIMARY            | <derived2> | ALL   | NULL                                              | NULL                          | NULL    | NULL             |  489 |   100.00 | Using where                                  |
|  3 | DEPENDENT SUBQUERY | T2         | ref   | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | i_ip_id_level_type_white_time | 195     | a.lip,const |    5 |   100.00 | Using where                                  |
|  2 | DERIVED            | T1         | range | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | idx2                          | 29      | NULL             |  489 |   100.00 | Using where; Using temporary; Using filesort |
+----+--------------------+------------+-------+---------------------------------------------------+-------------------------------+---------+------------------+------+----------+----------------------------------------------+
3 rows in set, 2 warnings (0.01 sec)


show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1276
Message: Field or reference 'a.lip' of SELECT #3 was resolved in SELECT #1
*************************** 2. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `a`.`lip` AS `lip`,`a`.`count` AS `count` from (/* select#2 */ select `db1`.`t1`.`LOGIN_IP` AS `lip`,count(`db1`.`t1`.`LOGIN_IP`) AS `count` from `db1`.`t_log` `t1` where ((`db1`.`t1`.`isw` = 0) and (`db1`.`t1`.`CUSTOMER_ID` = '200475639') and (`db1`.`t1`.`LOGIN_TIME` between '2017-05-22 12:57:36' and '2017-06-06 12:57:36') and (`db1`.`t1`.`pid` = 'xxx') and (`db1`.`t1`.`cll` <> 0) and (`db1`.`t1`.`cte` >= 1)) group by `db1`.`t1`.`LOGIN_IP`) `a` where exists(/* select#3 */ select 1 from `db1`.`t_log` `t2` where ((`db1`.`t2`.`isw` = 0) and (`db1`.`t2`.`CUSTOMER_ID` <> '200475639') and (`db1`.`t2`.`LOGIN_TIME` between '2017-05-22 12:57:36' and '2017-06-06 12:57:36') and (`db1`.`t2`.`cll` <> 0) and (`db1`.`t2`.`cte` >= 1) and (`db1`.`t2`.`pid` = 'xxx') and (`db1`.`t2`.`LOGIN_IP` = `a`.`lip`)))
2 rows in set (0.00 sec)



-- 未做分区前
-- 方法一:
SELECT 
    a.lip, a.count
FROM
    (SELECT 
        T1.lip, COUNT(T1.lip) AS count
    FROM
        t_log T1
    WHERE
        T1.cid = '200475639'
            AND T1.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
            AND T1.isw = 0
            AND T1.pid = 'xxx'
            AND T1.cll NOT IN (0)
            AND T1.cte >= 1
    GROUP BY T1.lip) a
WHERE
    a.lip IN (SELECT 
            T2.lip
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx')
-- 10 rows in set (1.55 sec)
-- 10 rows in set (1.30 sec)


-- 方法二:
SELECT 
    a.lip, a.count
FROM
    (SELECT 
        T1.lip, COUNT(T1.lip) AS count
    FROM
        t_log T1
    WHERE
        T1.cid = '200475639'
            AND T1.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
            AND T1.isw = 0
            AND T1.pid = 'xxx'
            AND T1.cll NOT IN (0)
            AND T1.cte >= 1
    GROUP BY T1.lip) a
WHERE
    EXISTS( SELECT 
            1
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 12:57:36' AND '2017-06-06 12:57:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx'
                AND T2.lip = a.lip)
-- 10 rows in set (3.22 sec)
-- 10 rows in set (1.66 sec)



origin:

SELECT
    T1.lip, COUNT(T1.lip) AS count
FROM
    t_log T1
WHERE
    T1.cid = '200475639'
        AND T1.lip IN (SELECT
            T2.lip
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 15:51:43' AND '2017-06-05 15:51:43'
                -- AND T2.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx')
        AND T1.lte BETWEEN '2017-05-22 15:51:43' AND '2017-06-05 15:51:43'
        -- AND T1.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T1.isw = 0
        AND T1.pid = 'xxx'
        AND T1.cll NOT IN (0)
        AND T1.cte >= 1
GROUP BY T1.lip;
+----------------+-------+
| lip       | count |
+----------------+-------+
| 10.16.209.254 |   236 |
| 11.136.41.58  |    20 |
| 22.240.60.39  |    26 |
| 32.104.1.103  |     2 |
| 32.104.1.241  |     4 |
| 32.104.1.247  |     2 |
+----------------+-------+
6 rows in set (4 min 21.60 sec)




zheng:

SELECT
    a.lip, a.count
FROM
    (SELECT 
        T1.lip, COUNT(T1.lip) AS count
    FROM
        t_log T1
    WHERE
        T1.cid = '200475639'
            AND T1.lte BETWEEN '2017-05-22 15:51:43' AND '2017-06-05 15:51:43'
            -- AND T1.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
            AND T1.isw = 0
            AND T1.pid = 'xxx'
            AND T1.cll NOT IN (0)
            AND T1.cte >= 1
    GROUP BY T1.lip) a
WHERE
    a.lip IN (SELECT 
            T2.lip
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 15:51:43' AND '2017-06-05 15:51:43'
                -- AND T2.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx');
+----------------+-------+
| lip       | count |
+----------------+-------+
| 10.16.209.254 |   236 |
| 11.136.41.58  |    20 |
| 22.240.60.39  |    26 |
| 32.104.1.103  |     2 |
| 32.104.1.241  |     4 |
| 32.104.1.247  |     2 |
+----------------+-------+
5 rows in set (1.71 sec)



-------------------------------------------------------------------

explain extended
SELECT 
    a.lip, a.count
FROM
    (SELECT 
        T1.lip, COUNT(T1.lip) AS count
    FROM
        t_log T1
    WHERE
        T1.cid = '1000511121'
            AND T1.lte BETWEEN '2017-05-20 15:51:43' AND '2017-06-04 15:51:43'
            AND T1.isw = 0
            AND T1.cll NOT IN (0)
            AND T1.cte >= 1
            AND T1.pid = 'xxx'
    GROUP BY T1.lip) a
WHERE
    EXISTS( SELECT 
            1
        FROM
            t_log T2
        WHERE
            T2.cid != '1000511121'
                AND T2.lte BETWEEN '2017-05-20 15:51:43' AND '2017-06-04 15:51:43'
                AND T2.isw = 0
                AND T2.pid = 'xxx'
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1);

+----+-------------+------------+-------+---------------------------------------------------+------+---------+------+---------+----------+---------------------------------------------------------------------+
| id | select_type | table      | type  | possible_keys                                     | key  | key_len | ref  | rows    | filtered | Extra                                                               |
+----+-------------+------------+-------+---------------------------------------------------+------+---------+------+---------+----------+---------------------------------------------------------------------+
|  1 | PRIMARY     | <derived2> | ALL   | NULL                                              | NULL | NULL    | NULL |     191 |   100.00 | NULL                                                                |
|  3 | SUBQUERY    | T2         | range | idx1,idx2,idx4                                    | idx4 | 24      | NULL | 2244130 |   100.00 | Using index condition; Using where                                  |
|  2 | DERIVED     | T1         | range | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | idx2 | 29      | NULL |     191 |   100.00 | Using index condition; Using where; Using temporary; Using filesort |
+----+-------------+------------+-------+---------------------------------------------------+------+---------+------+---------+----------+---------------------------------------------------------------------+
3 rows in set, 1 warning (0.00 sec)



show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `a`.`lip` AS `lip`,`a`.`count` AS `count` from (/* select#2 */ select `db1`.`t1`.`LOGIN_IP` AS `lip`,count(`db1`.`t1`.`LOGIN_IP`) AS `count` from `db1`.`t_log` `t1` where ((`db1`.`t1`.`isw` = 0) and (`db1`.`t1`.`CUSTOMER_ID` = '1000511121') and (`db1`.`t1`.`LOGIN_TIME` between '2017-05-20 15:51:43' and '2017-06-04 15:51:43') and (`db1`.`t1`.`cll` <> 0) and (`db1`.`t1`.`cte` >= 1) and (`db1`.`t1`.`pid` = 'xxx')) group by `db1`.`t1`.`LOGIN_IP`) `a` where exists(/* select#3 */ select 1 from `db1`.`t_log` `t2` where ((`db1`.`t2`.`isw` = 0) and (`db1`.`t2`.`CUSTOMER_ID` <> '1000511121') and (`db1`.`t2`.`LOGIN_TIME` between '2017-05-20 15:51:43' and '2017-06-04 15:51:43') and (`db1`.`t2`.`pid` = 'xxx') and (`db1`.`t2`.`cll` <> 0) and (`db1`.`t2`.`cte` >= 1)))



-- mysql version
select version();
+-----------------+
| version()       |
+-----------------+
| 5.6.27-75.0-log |
+-----------------+
1 row in set (0.01 sec)


-- t_log rows
select count(*) from t_log;
+----------+
| count(*) |
+----------+
| 12201551 |
+----------+
1 row in set (3.33 sec)


-- sql execution plan
explain extended
SELECT
    T1.lip, COUNT(T1.lip) AS count
FROM
    t_log T1
WHERE
    T1.cid = '200475639'
        AND T1.lip IN (SELECT 
            T2.lip
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx')
        AND T1.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T1.isw = 0
        AND T1.pid = 'xxx'
        AND T1.cll NOT IN (0)
        AND T1.cte >= 1
GROUP BY T1.lip;
+----+-------------+-------+-------+---------------------------------------------------+------+---------+--------------------+------+----------+---------------------------------------------------------------------+
| id | select_type | table | type  | possible_keys                                     | key  | key_len | ref                | rows | filtered | Extra                                                               |
+----+-------------+-------+-------+---------------------------------------------------+------+---------+--------------------+------+----------+---------------------------------------------------------------------+
|  1 | SIMPLE      | T1    | range | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | idx2 | 29      | NULL               |  489 |   100.00 | Using index condition; Using where; Using temporary; Using filesort |
|  1 | SIMPLE      | T2    | ref   | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | idx3 | 183     | db1.T1.LOGIN_IP |    4 |   100.00 | Using where; FirstMatch(T1)                                         |
+----+-------------+-------+-------+---------------------------------------------------+------+---------+--------------------+------+----------+---------------------------------------------------------------------+
2 rows in set, 1 warning (0.00 sec)


show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `db1`.`t1`.`LOGIN_IP` AS `lip`,count(`db1`.`t1`.`LOGIN_IP`) AS `count` from `db1`.`t_log` `t1` semi join (`db1`.`t_log` `t2`) where ((`db1`.`t2`.`LOGIN_IP` = `db1`.`t1`.`LOGIN_IP`) and (`db1`.`t2`.`isw` = 0) and (`db1`.`t1`.`isw` = 0) and (`db1`.`t1`.`CUSTOMER_ID` = '200475639') and (`db1`.`t1`.`LOGIN_TIME` between '2017-05-22 12:56:36' and '2017-06-06 12:56:36') and (`db1`.`t1`.`pid` = 'xxx') and (`db1`.`t1`.`cll` <> 0) and (`db1`.`t1`.`cte` >= 1) and (`db1`.`t2`.`CUSTOMER_ID` <> '200475639') and (`db1`.`t2`.`LOGIN_TIME` between '2017-05-22 12:56:36' and '2017-06-06 12:56:36') and (`db1`.`t2`.`cll` <> 0) and (`db1`.`t2`.`cte` >= 1) and (`db1`.`t2`.`pid` = 'xxx')) group by `db1`.`t1`.`LOGIN_IP`
1 row in set (0.00 sec)


-- 查询时间
SELECT
    T1.lip, COUNT(T1.lip) AS count
FROM
    t_log T1
WHERE
    T1.cid = '200475639'
        AND T1.lip IN (SELECT 
            T2.lip
        FROM
            t_log T2
        WHERE
            T2.cid != '200475639'
                AND T2.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
                AND T2.isw = 0
                AND T2.cll NOT IN (0)
                AND T2.cte >= 1
                AND T2.pid = 'xxx')
        AND T1.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T1.isw = 0
        AND T1.pid = 'xxx'
        AND T1.cll NOT IN (0)
        AND T1.cte >= 1
GROUP BY T1.lip;
+----------------+-------+
| lip       | count |
+----------------+-------+
| 10.10.10.254  |   236 |
| 20.136.41.58  |    28 |
| 30.136.79.39  |    16 |
| 40.136.79.47  |     2 |
| 50.240.60.39  |    26 |
| 50.104.1.103  |     2 |
| 50.104.1.241  |     4 |
| 60.104.1.247  |     2 |
| 60.104.1.249  |    14 |
| 60.104.1.253  |    30 |
+----------------+-------+
10 rows in set (4 min 21.78 sec)



-- 子查询部分执行的时间
SELECT
    T2.lip
FROM
    t_log T2
WHERE
    T2.cid != '200475639'
        AND T2.lte BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T2.isw = 0
        AND T2.cll NOT IN (0)
        AND T2.cte >= 1
        AND T2.pid = 'xxx';
+--------------------+
| count(T2.lip) |
+--------------------+
|             982214 |
+--------------------+
1 row in set (8.01 sec)



