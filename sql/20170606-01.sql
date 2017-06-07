explain extended
SELECT 
    a.login_ip, a.count
FROM
    (SELECT 
        T1.login_ip, COUNT(T1.login_ip) AS count
    FROM
        t_login_items T1
    WHERE
        T1.customer_id = '1000511121'
            AND T1.login_time BETWEEN '2017-05-20 15:51:43' AND '2017-06-04 15:51:43'
            AND T1.IS_WHITE = 0
            AND T1.customer_level NOT IN (0)
            AND T1.CUSTOMER_TYPE >= 1
            AND T1.PRODUCT_ID = 'A01'
    GROUP BY T1.login_ip) a
WHERE
    EXISTS( SELECT 
            1
        FROM
            t_login_items T2
        WHERE
            T2.customer_id != '1000511121'
                AND T2.login_time BETWEEN '2017-05-20 15:51:43' AND '2017-06-04 15:51:43'
                AND T2.IS_WHITE = 0
                AND T2.PRODUCT_ID = 'A01'
                AND T2.customer_level NOT IN (0)
                AND T2.CUSTOMER_TYPE >= 1);

+----+-------------+------------+-------+---------------------------------------------------+------+---------+------+---------+----------+---------------------------------------------------------------------+
| id | select_type | table      | type  | possible_keys                                     | key  | key_len | ref  | rows    | filtered | Extra                                                               |
+----+-------------+------------+-------+---------------------------------------------------+------+---------+------+---------+----------+---------------------------------------------------------------------+
|  1 | PRIMARY     | <derived2> | ALL   | NULL                                              | NULL | NULL    | NULL |     191 |   100.00 | NULL                                                                |
|  3 | SUBQUERY    | T2         | range | idx1,idx2,idx4                                    | idx4 | 24      | NULL | 2244130 |   100.00 | Using index condition; Using where                                  |
|  2 | DERIVED     | T1         | range | idx1,i_ip_id_level_type_white_time,idx3,idx2,idx4 | idx2 | 29      | NULL |     191 |   100.00 | Using index condition; Using where; Using temporary; Using filesort |
+----+-------------+------------+-------+---------------------------------------------------+------+---------+------+---------+----------+---------------------------------------------------------------------+
3 rows in set, 1 warning (0.00 sec)



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
    T1.login_ip, COUNT(T1.login_ip) AS count
FROM
    t_log T1
WHERE
    T1.customer_id = '1000473649'
        AND T1.login_ip IN (SELECT 
            T2.login_ip
        FROM
            t_log T2
        WHERE
            T2.customer_id != '1000473649'
                AND T2.login_time BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
                AND T2.IS_WHITE = 0
                AND T2.customer_level NOT IN (0)
                AND T2.CUSTOMER_TYPE >= 1
                AND T2.PRODUCT_ID = 'A01')
        AND T1.login_time BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T1.IS_WHITE = 0
        AND T1.PRODUCT_ID = 'A01'
        AND T1.customer_level NOT IN (0)
        AND T1.CUSTOMER_TYPE >= 1
GROUP BY T1.login_ip;
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
Message: /* select#1 */ select `db1`.`t1`.`LOGIN_IP` AS `login_ip`,count(`db1`.`t1`.`LOGIN_IP`) AS `count` from `db1`.`t_log` `t1` semi join (`db1`.`t_log` `t2`) where ((`db1`.`t2`.`LOGIN_IP` = `db1`.`t1`.`LOGIN_IP`) and (`db1`.`t2`.`IS_WHITE` = 0) and (`db1`.`t1`.`IS_WHITE` = 0) and (`db1`.`t1`.`CUSTOMER_ID` = '1000473649') and (`db1`.`t1`.`LOGIN_TIME` between '2017-05-22 12:56:36' and '2017-06-06 12:56:36') and (`db1`.`t1`.`PRODUCT_ID` = 'A01') and (`db1`.`t1`.`customer_level` <> 0) and (`db1`.`t1`.`CUSTOMER_TYPE` >= 1) and (`db1`.`t2`.`CUSTOMER_ID` <> '1000473649') and (`db1`.`t2`.`LOGIN_TIME` between '2017-05-22 12:56:36' and '2017-06-06 12:56:36') and (`db1`.`t2`.`customer_level` <> 0) and (`db1`.`t2`.`CUSTOMER_TYPE` >= 1) and (`db1`.`t2`.`PRODUCT_ID` = 'A01')) group by `db1`.`t1`.`LOGIN_IP`
1 row in set (0.00 sec)


-- 查询时间
SELECT
    T1.login_ip, COUNT(T1.login_ip) AS count
FROM
    t_log T1
WHERE
    T1.customer_id = '1000473649'
        AND T1.login_ip IN (SELECT 
            T2.login_ip
        FROM
            t_log T2
        WHERE
            T2.customer_id != '1000473649'
                AND T2.login_time BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
                AND T2.IS_WHITE = 0
                AND T2.customer_level NOT IN (0)
                AND T2.CUSTOMER_TYPE >= 1
                AND T2.PRODUCT_ID = 'A01')
        AND T1.login_time BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T1.IS_WHITE = 0
        AND T1.PRODUCT_ID = 'A01'
        AND T1.customer_level NOT IN (0)
        AND T1.CUSTOMER_TYPE >= 1
GROUP BY T1.login_ip;
+----------------+-------+
| login_ip       | count |
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
    T2.login_ip
FROM
    t_log T2
WHERE
    T2.customer_id != '1000473649'
        AND T2.login_time BETWEEN '2017-05-22 12:56:36' AND '2017-06-06 12:56:36'
        AND T2.IS_WHITE = 0
        AND T2.customer_level NOT IN (0)
        AND T2.CUSTOMER_TYPE >= 1
        AND T2.PRODUCT_ID = 'A01';
+--------------------+
| count(T2.login_ip) |
+--------------------+
|             982214 |
+--------------------+
1 row in set (8.01 sec)


-- 表结构
CREATE TABLE `t_log` (
  `ITEM_ID` varchar(40) NOT NULL,
  `CUSTOMER_ID` int(22) DEFAULT NULL,
  `CUSTOMER_TYPE` tinyint(1) DEFAULT NULL,
  `PRODUCT_ID` varchar(3) DEFAULT NULL,
  `LOGIN_NAME` varchar(50) DEFAULT NULL,
  `LOGIN_WEBSITE` varchar(200) DEFAULT NULL,
  `LOGIN_GAME` varchar(10) DEFAULT NULL,
  `LOGIN_TIME` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `LOGIN_IP` varchar(60) DEFAULT NULL,
  `LOGIN_END_POINT_TYPE` varchar(3) DEFAULT NULL,
  `customer_level` int(1) DEFAULT NULL,
  `IS_WHITE` int(1) DEFAULT '0',
  PRIMARY KEY (`ITEM_ID`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

