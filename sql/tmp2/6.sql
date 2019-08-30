[40 sys@127.0.0.1 192.168.94.168:3307 2019-08-30_08:18:08_5_+08 (db1)]
SQL> show create table t1\G
*************************** 1. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `openid` varchar(255) CHARACTER SET utf8 NOT NULL,
  `c1` varchar(255) CHARACTER SET utf8 NOT NULL,
  `c2` varchar(255) CHARACTER SET utf8 NOT NULL,
  `c3` bigint(20) NOT NULL,
  PRIMARY KEY (`openid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
1 row in set (0.00 sec)

[41 sys@127.0.0.1 192.168.94.168:3307 2019-08-30_08:19:59_5_+08 (db1)]
SQL> show create table t2\G
*************************** 1. row ***************************
       Table: t2
Create Table: CREATE TABLE `t2` (
  `customerid` int(11) NOT NULL AUTO_INCREMENT,
  `c1` varchar(30) DEFAULT NULL,
  `c2` char(18) DEFAULT NULL,
  `c3` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`customerid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

[36 sys@127.0.0.1 192.168.94.168:3307 2019-08-30_08:17:37_5_+08 (db1)]
SQL> select * from t1;
+--------+----+----+----+
| openid | c1 | c2 | c3 |
+--------+----+----+----+
| 1      | a  | b  | 10 |
| 2      | a  | b  | 11 |
| 3      | c  | d  | 12 |
| 4      | a  | b  | 10 |
| 5      | a  | b  | 10 |
| 6      | a  | b  | 10 |
+--------+----+----+----+
6 rows in set (0.00 sec)

[37 sys@127.0.0.1 192.168.94.168:3307 2019-08-30_08:17:45_5_+08 (db1)]
SQL> select * from t2;
+------------+------+------+------+
| customerid | c1   | c2   | c3   |
+------------+------+------+------+
|          1 | c    | d    |   12 |
|          2 | c    | d    |   12 |
|          3 | a    | b    |   10 |
|          4 | a    | b    |   11 |
|          5 | c    | d    |   12 |
|          6 | a    | b    |   10 |
|          7 | a    | b    |   10 |
|          8 | a    | b    |   10 |
+------------+------+------+------+
8 rows in set (0.00 sec)

[42 sys@127.0.0.1 192.168.94.168:3307 2019-08-30_08:20:01_5_+08 (db1)]
SQL> desc 
    -> select * from t2 left join (
    -> select openid,c1,c2,c3
    -> from
    ->      t1
    -> group by 
    ->      c1,c2,c3
    -> ) bind on bind.c2 = t2.c2
    -> and bind.c1 = t2.c1
    -> and bind.c3 = t2.c3;
+----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table      | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | PRIMARY     | t2         | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    8 |   100.00 | NULL                                               |
|  1 | PRIMARY     | <derived2> | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |   100.00 | Using where; Using join buffer (Block Nested Loop) |
|  2 | DERIVED     | t1         | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    6 |   100.00 | Using temporary; Using filesort                    |
+----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
3 rows in set, 1 warning (0.00 sec)


