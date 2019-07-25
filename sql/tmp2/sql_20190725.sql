SQL> show create table t_visitor\G
*************************** 1. row ***************************
       Table: t_visitor
Create Table: CREATE TABLE t_visitor (
  customer_id bigint(22) NOT NULL ,
  login_name varchar(20) NOT NULL ,
  product_id varchar(3) NOT NULL ,
  contract varchar(22) NOT NULL DEFAULT '2017000000000' ,
  cm_status int(2) NOT NULL DEFAULT '1' ,
  cm_credit decimal(22,6) NOT NULL DEFAULT '0.000000' ,
  cm_in int(1) NOT NULL DEFAULT '0' ,
  start_date datetime DEFAULT NULL ,
  last_update datetime DEFAULT NULL ,
  last_updated_by varchar(20) DEFAULT NULL ,
  parent_id bigint(22) DEFAULT NULL ,
  created_date datetime DEFAULT NULL ,
  created_by varchar(20) DEFAULT NULL ,
  domain_name varchar(50) DEFAULT NULL ,
  child_level int(4) NOT NULL DEFAULT '0' ,
  line_type int(1) DEFAULT '0' ,
  line_cont varchar(22) DEFAULT NULL ,
  palcode varchar(22) DEFAULT NULL ,
  is_need_check int(1) NOT NULL DEFAULT '0' ,
  register tinyint(1) NOT NULL DEFAULT '0' ,
  line_cont varchar(22) NOT NULL DEFAULT '' ,
  first_count int(11) NOT NULL DEFAULT '0' ,
  sec_count int(11) NOT NULL DEFAULT '0' ,
  thr_count int(11) NOT NULL DEFAULT '0' ,
  curr varchar(45) NOT NULL DEFAULT '',
  main_id bigint(20) DEFAULT NULL,
  sk_type tinyint(1) NOT NULL DEFAULT '0' ,
  match_date datetime DEFAULT NULL ,
  level_count tinyint(4) NOT NULL DEFAULT '0' ,
  cm_enabled_time datetime NOT NULL DEFAULT '2000-01-01 00:00:00' ,
  customer_type tinyint(1) NOT NULL DEFAULT '1' ,
  flag tinyint(1) NOT NULL DEFAULT '1' ,
  is_market tinyint(1) NOT NULL DEFAULT '0' ,
  dl_ds tinyint(1) NOT NULL DEFAULT '0' ,
  dl_at tinyint(1) NOT NULL DEFAULT '0' ,
  dl_pd tinyint(1) NOT NULL DEFAULT '0' ,
  priority_level tinyint(3) NOT NULL DEFAULT '0' ,
  deposit_level tinyint(3) NOT NULL DEFAULT '0' ,
  customer_level tinyint(3) NOT NULL DEFAULT '0' ,
  show_name tinyint(1) NOT NULL DEFAULT '0' ,
  enabled_time datetime DEFAULT NULL ,
  is_bi tinyint(1) NOT NULL DEFAULT '0' ,
  credit_sign varchar(50) NOT NULL DEFAULT '' ,
  credit_flag tinyint(1) NOT NULL DEFAULT '0' ,
  show_dl tinyint(1) unsigned NOT NULL DEFAULT '1' ,
  first_login_date datetime DEFAULT NULL ,
  last_login_date datetime DEFAULT NULL ,
  web_resource varchar(200) NOT NULL DEFAULT '' ,
  is_needp tinyint(1) NOT NULL DEFAULT '0' ,
  packages varchar(200) NOT NULL DEFAULT '' ,
  registers varchar(3) NOT NULL DEFAULT '' ,
  pwd varchar(32) NOT NULL DEFAULT '' ,
  PRIMARY KEY (customer_id,product_id),
  KEY index_parent_id (parent_id,product_id),
  KEY i_aaa (agent_level_count,product_id),
  KEY i_ccc (login_name,product_id,first_count),
  KEY i_ddd (contract_code),
  KEY i_eee (product_id,login_name,first_count,agent_level_count,currency),
  KEY i_fff (product_id,customer_type),
  KEY i_bbb (product_id,created_date),
  KEY i_ggg (product_id,is_bi_merchant),
  KEY i_hhh (domain_name,product_id),
  KEY i_iii (product_id,is_need_package),
  KEY i_zzz (product_id,parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)




SQL> desc 
    -> UPDATE t_visitor 
    -> SET 
    ->     first_count = (SELECT 
    ->             first_count
    ->         FROM
    ->             (SELECT 
    ->                 COUNT(*) AS first_count
    ->             FROM
    ->                 t_visitor
    ->             WHERE
    ->                 parent_id = 1997070701
    ->                     AND product_id = 'bike') firstCount),
    ->     sec_count = (SELECT 
    ->             sec_count
    ->         FROM
    ->             (SELECT 
    ->                 COUNT(*) AS sec_count
    ->             FROM
    ->                 t_visitor t1
    ->             INNER JOIN t_visitor t2 ON t1.customer_id = t2.parent_id
    ->                 AND t1.product_id = t2.product_id
    ->             WHERE
    ->                 t1.parent_id = 1997070701
    ->                     AND t1.product_id = 'bike') secCount),
    ->     thr_count = (SELECT 
    ->             thr_count
    ->         FROM
    ->             (SELECT 
    ->                 COUNT(1) AS thr_count
    ->             FROM
    ->                 t_visitor t11 
    ->             INNER JOIN t_visitor t12 ON t11.customer_id = t12.parent_id
    ->                 AND t11.product_id = t12.product_id
    ->             INNER JOIN t_visitor t13 ON t12.customer_id = t13.parent_id
    ->                 AND t12.product_id = t13.product_id
    ->             WHERE
    ->                 t11.parent_id = 1997070701
    ->                     AND t11.product_id = 'bike') thrCount)
    -> WHERE
    ->     product_id = 'bike'
    ->         AND customer_id = 1997070701;
+----+-------------+-------------------+------------+--------+-------------------------------------------------------------+-----------------+---------+----------------------------------------+--------+----------+--------------------------+
| id | select_type | table             | partitions | type   | possible_keys                                               | key             | key_len | ref                                    | rows   | filtered | Extra                    |
+----+-------------+-------------------+------------+--------+-------------------------------------------------------------+-----------------+---------+----------------------------------------+--------+----------+--------------------------+
|  1 | UPDATE      | t_visitor | NULL       | range  | PRIMARY,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz                 | PRIMARY         | 19      | const,const                            |      1 |   100.00 | Using where              |
|  6 | SUBQUERY    | <derived7>        | NULL       | system | NULL                                                        | NULL            | NULL    | NULL                                   |      1 |   100.00 | NULL                     |
|  7 | DERIVED     | t12               | NULL       | ref    | PRIMARY,index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii       | i_iii           | 11      | const                                  | 345772 |   100.00 | Using where              |
|  7 | DERIVED     | t11               | NULL       | eq_ref | PRIMARY,index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii       | PRIMARY         | 19      | db1.t12.parent_id,const   |      1 |     5.00 | Using where              |
|  7 | DERIVED     | t13               | NULL       | ref    | index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii               | index_parent_id | 20      | db1.t12.customer_id,const |    112 |   100.00 | Using where; Using index |
|  4 | SUBQUERY    | <derived5>        | NULL       | system | NULL                                                        | NULL            | NULL    | NULL                                   |      1 |   100.00 | NULL                     |
|  5 | DERIVED     | t2                | NULL       | ref    | index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz         | i_zzz           | 11      | const                                  | 596162 |   100.00 | Using where; Using index |
|  5 | DERIVED     | t1                | NULL       | eq_ref | PRIMARY,index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz | PRIMARY         | 19      | db1.t2.parent_id,const    |      1 |     5.00 | Using where              |
|  2 | SUBQUERY    | <derived3>        | NULL       | system | NULL                                                        | NULL            | NULL    | NULL                                   |      1 |   100.00 | NULL                     |
|  3 | DERIVED     | t_visitor | NULL       | ref    | index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz         | index_parent_id | 20      | const,const                            | 172270 |   100.00 | Using index              |
+----+-------------+-------------------+------------+--------+-------------------------------------------------------------+-----------------+---------+----------------------------------------+--------+----------+--------------------------+
10 rows in set (0.99 sec)



### first_count ###
SQL> desc SELECT 
            COUNT(*) AS first_count
        FROM
            t_visitor
        WHERE
            parent_id = 1997070701
                AND product_id = 'bike';
+----+-------------+-------------------+------------+------+-----------------------------------------------------+-----------------+---------+-------------+--------+----------+-------------+
| id | select_type | table             | partitions | type | possible_keys                                       | key             | key_len | ref         | rows   | filtered | Extra       |
+----+-------------+-------------------+------------+------+-----------------------------------------------------+-----------------+---------+-------------+--------+----------+-------------+
|  1 | SIMPLE      | t_visitor | NULL       | ref  | index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz | index_parent_id | 20      | const,const | 172270 |   100.00 | Using index |
+----+-------------+-------------------+------------+------+-----------------------------------------------------+-----------------+---------+-------------+--------+----------+-------------+
1 row in set, 1 warning (0.00 sec)


SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select count(0) AS first_count from db1.t_visitor where ((db1.t_visitor.parent_id = 1997070701) and (db1.t_visitor.product_id = 'bike'))
1 row in set (0.00 sec)



SQL> SELECT 
    ->                 COUNT(*) AS first_count
    ->             FROM
    ->                 t_visitor
    ->             WHERE
    ->                 parent_id = 1997070701
    ->                     AND product_id = 'bike';
+------------------+
| first_count |
+------------------+
|           130675 |
+------------------+
1 row in set (0.03 sec)




### sec_count ###
SQL> desc SELECT 
           COUNT(*) AS sec_count
       FROM
           t_visitor t1
       INNER JOIN t_visitor t2 ON t1.customer_id = t2.parent_id
           AND t1.product_id = t2.product_id
       WHERE
           t1.parent_id = 1997070701
               AND t1.product_id = 'bike';
+----+-------------+-------+------------+--------+-------------------------------------------------------------+---------+---------+-------------------------------------+--------+----------+--------------------------+
| id | select_type | table | partitions | type   | possible_keys                                               | key     | key_len | ref                                 | rows   | filtered | Extra                    |
+----+-------------+-------+------------+--------+-------------------------------------------------------------+---------+---------+-------------------------------------+--------+----------+--------------------------+
|  1 | SIMPLE      | t2    | NULL       | ref    | index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz         | i_zzz   | 11      | const                               | 597390 |   100.00 | Using where; Using index |
|  1 | SIMPLE      | t1    | NULL       | eq_ref | PRIMARY,index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz | PRIMARY | 19      | db1.t2.parent_id,const |      1 |     5.00 | Using where              |
+----+-------------+-------+------------+--------+-------------------------------------------------------------+---------+---------+-------------------------------------+--------+----------+--------------------------+
2 rows in set, 1 warning (0.00 sec)


SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select count(0) AS sec_count from db1.t_visitor t1 join db1.t_visitor t2 where ((db1.t1.product_id = db1.t2.product_id) and (db1.t1.customer_id = db1.t2.parent_id) and (db1.t1.parent_id = 1997070701) and (db1.t2.product_id = 'bike'))
1 row in set (0.00 sec)



SQL> SELECT 
    ->                 COUNT(*) AS sec_count
    ->             FROM
    ->                 t_visitor t1
    ->             INNER JOIN t_visitor t2 ON t1.customer_id = t2.parent_id
    ->                 AND t1.product_id = t2.product_id
    ->             WHERE
    ->                 t1.parent_id = 1997070701
    ->                     AND t1.product_id = 'bike';
+----------------+
| sec_count |
+----------------+
|          35649 |
+----------------+
1 row in set (0.12 sec)



### thr_count ###
SQL> desc SELECT 
            COUNT(1) AS thr_count
        FROM
            t_visitor t11 
        INNER JOIN t_visitor t12 ON t11.customer_id = t12.parent_id
            AND t11.product_id = t12.product_id
        INNER JOIN t_visitor t13 ON t12.customer_id = t13.parent_id
            AND t12.product_id = t13.product_id
        WHERE
            t11.parent_id = 1997070701
                AND t11.product_id = 'bike';

+----+-------------+-------+------------+--------+-------------------------------------------------------------+---------+---------+----------------------------------------+--------+----------+--------------------------+
| id | select_type | table | partitions | type   | possible_keys                                               | key     | key_len | ref                                    | rows   | filtered | Extra                    |
+----+-------------+-------+------------+--------+-------------------------------------------------------------+---------+---------+----------------------------------------+--------+----------+--------------------------+
|  1 | SIMPLE      | t12   | NULL       | ref    | PRIMARY,index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz | i_zzz   | 11      | const                                  | 557726 |   100.00 | Using where; Using index |
|  1 | SIMPLE      | t11   | NULL       | eq_ref | PRIMARY,index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz | PRIMARY | 19      | db1.t12.parent_id,const   |      1 |     5.00 | Using where              |
|  1 | SIMPLE      | t13   | NULL       | ref    | index_parent_id,i_eee,i_fff,i_bbb,i_ggg,i_iii,i_zzz         | i_zzz   | 20      | const,db1.t12.customer_id |     96 |   100.00 | Using where; Using index |
+----+-------------+-------+------------+--------+-------------------------------------------------------------+---------+---------+----------------------------------------+--------+----------+--------------------------+
3 rows in set, 1 warning (0.00 sec)


SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select count(1) AS `thr_count` from `db1`.`t_visitor` `t11` join `db1`.`t_visitor` `t12` join `db1`.`t_visitor` `t13` where ((`db1`.`t11`.`customer_id` = `db1`.`t12`.`parent_id`) and (`db1`.`t11`.`product_id` = `db1`.`t12`.`product_id`) and (`db1`.`t13`.`product_id` = `db1`.`t12`.`product_id`) and (`db1`.`t13`.`parent_id` = `db1`.`t12`.`customer_id`) and (`db1`.`t11`.`parent_id` = 1997070701) and (`db1`.`t12`.`product_id` = 'bike'))
1 row in set (0.00 sec)



SQL> SELECT 
    ->                 COUNT(1) AS thr_count
    ->             FROM
    ->                 t_visitor t11
    ->             INNER JOIN t_visitor t12 ON t11.customer_id = t12.parent_id
    ->                 AND t11.product_id = t12.product_id
    ->             INNER JOIN t_visitor t13 ON t12.customer_id = t13.parent_id
    ->                 AND t12.product_id = t13.product_id
    ->             WHERE
    ->                 t11.parent_id = 1997070701
    ->                     AND t11.product_id = 'bike';
+----------------+
| thr_count |
+----------------+
|          99314 |
+----------------+
1 row in set (0.24 sec)