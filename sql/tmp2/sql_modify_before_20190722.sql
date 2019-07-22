慢SQL,不同产品数据量不同,第3次统计的时候最下面2层select比较快，多加一层就会生成40w左右回表，导致很慢，现在想优化这点
此SQL并发量比较高,一次执行慢，就会导致整体慢


UPDATE same_a_table AS t1 
SET 
    first_count = (SELECT 
            first_count
        FROM
            (SELECT 
                COUNT(1) AS first_count
            FROM
                same_a_table AS t2
            WHERE
                parent_id = 199707010701
                    AND product_id = 'bike') firstCount),
    sec_count = (SELECT 
            sec_count
        FROM
            (SELECT 
                COUNT(1) AS sec_count
            FROM
                same_a_table AS t3
            WHERE
                parent_id IN (SELECT 
                        customer_id
                    FROM
                        same_a_table AS t4
                    WHERE
                        parent_id = 199707010701
                            AND product_id = 'bike')
                    AND product_id = 'bike') secCount),
    thr_count = (SELECT 
            thr_count
        FROM
            (SELECT 
                COUNT(1) AS thr_count
            FROM
                same_a_table AS t5
            WHERE
                parent_id IN (SELECT 
                        customer_id
                    FROM
                        same_a_table AS t6
                    WHERE
                        parent_id IN (SELECT 
                                customer_id
                            FROM
                                same_a_table AS t7
                            WHERE
                                parent_id = 199707010701
                                    AND product_id = 'bike')
                            AND product_id = 'bike')
                    AND product_id = 'bike') thrCount)
WHERE
    product_id = 'bike'
        AND customer_id = 199707010701;
-------------+------------+------------+--------+-------------------------------------------------------+-----------------+---------+---------------------------------------+--------+----------+-------------+
| id | select_type | table      | partitions | type   | possible_keys                                         | key             | key_len | ref                                   | rows   | filtered | Extra       |
-------------+------------+------------+--------+-------------------------------------------------------+-----------------+---------+---------------------------------------+--------+----------+-------------+
|  1 | UPDATE      | t1         | NULL       | range  | PRIMARY,i_eee,i_fff,i_bbb,i_ggg,i_iii                 | PRIMARY         | 19      | const,const                     |      1 |   100.00 | Using where |
|  7 | SUBQUERY    | <derived8> | NULL       | system | NULL                                                  | NULL            | NULL    | NULL                            |      1 |   100.00 | NULL        |
|  8 | DERIVED     | t6         | NULL       | ref    | PRIMARY,i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | i_iii           | 11      | const                           | 389228 |   100.00 | Using where |
|  8 | DERIVED     | t7         | NULL       | eq_ref | PRIMARY,i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | PRIMARY         | 19      | db1.t6.parent_id,const          |      1 |     5.00 | Using where |
|  8 | DERIVED     | t5         | NULL       | ref    | i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii                   | i_aaa | 20      | db1.t6.customer_id,const                  |    111 |   100.00 | Using index |
|  4 | SUBQUERY    | <derived5> | NULL       | system | NULL                                                  | NULL            | NULL    | NULL                            |      1 |   100.00 | NULL        |
|  5 | DERIVED     | t4         | NULL       | ref    | PRIMARY,i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | i_aaa           | 20      | const,const                     |   2449 |   100.00 | Using index |
|  5 | DERIVED     | t3         | NULL       | ref    | i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii                   | i_aaa | 20      | db1.t4.customer_id,const                  |    111 |   100.00 | Using index |
|  2 | SUBQUERY    | <derived3> | NULL       | system | NULL                                                  | NULL            | NULL    | NULL                            |      1 |   100.00 | NULL        |
|  3 | DERIVED     | t2         | NULL       | ref    | i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii                   | i_aaa | 20      | const,const                               |   2449 |   100.00 | Using index |
-------------+------------+------------+--------+-------------------------------------------------------+-----------------+---------+---------------------------------------+--------+----------+-------------+
10 rows in set (0.68 sec)

update语句没有看到show warnings;



=====================================================================================
same_a_table表字段:
customer_id bigint
product_id  varchar
parent_id   bigint


index:
PRIMARY KEY (`customer_id`,`product_id`)
KEY `i_aaa` (`parent_id`,`product_id`)
KEY `i_iii` (`product_id`,`is_need_package`)
=====================================================================================



第1部分查询比较慢thr_count:
SQL> desc SELECT 
    ->             first_count
    ->         FROM
    ->             (SELECT 
    ->                 COUNT(1) AS first_count
    ->             FROM
    ->                 same_a_table t2
    ->             WHERE
    ->                 parent_id = 199707010701
    ->                     AND product_id = 'bike') firstCount;
+----+-------------+------------+------------+--------+-----------------------------------------------+-----------------+---------+-------------+------+----------+-------------+
| id | select_type | table      | partitions | type   | possible_keys                                 | key             | key_len | ref         | rows | filtered | Extra       |
+----+-------------+------------+------------+--------+-----------------------------------------------+-----------------+---------+-------------+------+----------+-------------+
|  1 | PRIMARY     | <derived2> | NULL       | system | NULL                                          | NULL            | NULL    | NULL        |    1 |   100.00 | NULL        |
|  2 | DERIVED     | t2         | NULL       | ref    | i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | i_aaa           | 20      | const,const | 2449 |   100.00 | Using index |
+----+-------------+------------+------------+--------+-----------------------------------------------+-----------------+---------+-------------+------+----------+-------------+
2 rows in set, 1 warning (0.00 sec)


SQL> SELECT  first_count    FROM     (SELECT    COUNT(1) AS first_count  FROM  same_a_table t2   WHERE  parent_id = 199707010701  AND product_id = 'bike') firstCount;     
+------------------+
| first_count |
+------------------+
|             2449 |
+------------------+
1 row in set (0.01 sec)



第2部分查询比较慢thr_count:
SQL> desc
    -> SELECT 
    ->                 COUNT(1) AS sec_count
    ->             FROM
    ->                 same_a_table t3
    ->             WHERE
    ->                 parent_id IN (SELECT 
    ->                         customer_id
    ->                     FROM
    ->                         same_a_table t4
    ->                     WHERE
    ->                         parent_id = 199707010701
    ->                             AND product_id = 'bike')
    ->                     AND product_id = 'bike';
+----+-------------+-------+------------+------+-------------------------------------------------------+-----------------+---------+---------------------------------------+------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys                                         | key             | key_len | ref                      | rows |     filtered | Extra       |
+----+-------------+-------+------------+------+-------------------------------------------------------+-----------------+---------+---------------------------------------+------+----------+-------------+
|  1 | SIMPLE      | t4    | NULL       | ref  | PRIMARY,i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | i_aaa           | 20      | const,const              | 2449 |     100.00   | Using index |
|  1 | SIMPLE      | t3    | NULL       | ref  | i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii                   | i_aaa           | 20      | db1.t4.customer_id,const |  111 |     100.00   | Using index |
+----+-------------+-------+------------+------+-------------------------------------------------------+-----------------+---------+---------------------------------------+------+----------+-------------+
2 rows in set, 1 warning (0.00 sec)

SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select count(1) AS `sec_count` from `db1`.`same_a_table` `t4` join `db1`.`same_a_table` `t3` where ((`db1`.`t3`.`parent_id` = `db1`.`t4`.`customer_id`) and (`db1`.`t4`.`parent_id` = 199707010701) and (`db1`.`t3`.`product_id` = 'bike') and (`db1`.`t4`.`product_id` = 'bike'))
1 row in set (0.00 sec)



SQL> SELECT  sec_count  FROM (SELECT  COUNT(1) AS sec_count  FROM  same_a_table t3 WHERE  parent_id IN (SELECT  customer_id  FROM  same_a_table t4  WHERE  parent_id = 199707010701 AND product_id = 'bike')   AND product_id = 'bike') secDwonCount;     
+----------------+
| sec_count |
+----------------+
|            291 |
+----------------+
1 row in set (0.00 sec)



第3部分查询比较慢thr_count:
SQL> desc 
    -> SELECT 
    ->                 COUNT(1) AS thr_count
    ->             FROM
    ->                 same_a_table t5
    ->             WHERE
    ->                 parent_id IN (SELECT 
    ->                         customer_id
    ->                     FROM
    ->                         same_a_table t6
    ->                     WHERE
    ->                         parent_id IN (SELECT 
    ->                                 customer_id
    ->                             FROM
    ->                                 same_a_table t7
    ->                             WHERE
    ->                                 parent_id = 199707010701
    ->                                     AND product_id = 'bike')
    ->                             AND product_id = 'bike')
    ->                     AND product_id = 'bike';
----+-------------+-------+------------+--------+-------------------------------------------------------+-----------------+---------+---------------------------------------+--------+----------+-------------+
| id | select_type | table | partitions | type   | possible_keys                                         | key             | key_len | ref                                | rows   | filtered | Extra       |
----+-------------+-------+------------+--------+-------------------------------------------------------+-----------------+---------+---------------------------------------+--------+----------+-------------+
|  1 | SIMPLE      | t6    | NULL       | ref    | PRIMARY,i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | i_iii           | 11      | const                              | 390264 |   100.00 | Using where |
|  1 | SIMPLE      | t7    | NULL       | eq_ref | PRIMARY,i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii           | PRIMARY         | 19      | db1.t6.parent_id,const             |      1 |     5.00 | Using where |
|  1 | SIMPLE      | t5    | NULL       | ref    | i_aaa,i_eee,i_fff,i_bbb,i_ggg,i_iii                   | i_aaa           | 20      | db1.t6.customer_id,const           |    111 |   100.00 | Using index |
+----+-------------+-------+------------+--------+-------------------------------------------------------+-----------------+---------+---------------------------------------+--------+----------+-------------+
3 rows in set, 1 warning (0.00 sec)


SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select count(1) AS `thr_count` from `db1`.`same_a_table` `t7` join `db1`.`same_a_table` `t6` join `db1`.`same_a_table` `t5` where ((`db1`.`t5`.`parent_id` = `db1`.`t6`.`customer_id`) and (`db1`.`t7`.`customer_id` = `db1`.`t6`.`parent_id`) and (`db1`.`t7`.`parent_id` = 199707010701) and (`db1`.`t5`.`product_id` = 'bike') and (`db1`.`t6`.`product_id` = 'bike') and (`db1`.`t7`.`product_id` = 'bike'))
1 row in set (0.00 sec)


SQL> SELECT 
    ->             thr_count
    ->         FROM
    ->             (SELECT 
    ->                 COUNT(1) AS thr_count
    ->             FROM
    ->                 same_a_table t5
    ->             WHERE
    ->                 parent_id IN (SELECT 
    ->                         customer_id
    ->                     FROM
    ->                         same_a_table t6
    ->                     WHERE
    ->                         parent_id IN (SELECT 
    ->                                 customer_id
    ->                             FROM
    ->                                 same_a_table t7
    ->                             WHERE
    ->                                 parent_id = 199707010701
    ->                                     AND product_id = 'bike')
    ->                             AND product_id = 'bike')
    ->                     AND product_id = 'bike') thrCount;
+----------------+
| thr_count |
+----------------+
|             43 |
+----------------+
1 row in set (0.59 sec)
