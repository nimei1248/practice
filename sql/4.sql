-- mysql version
[138 sys@localhost 2017-05-22_17:41:06 (employees)]
SQL> select version();
+---------------+
| version()     |
+---------------+
| 5.7.17-13-log |
+---------------+
1 row in set (0.00 sec)


-- XFS file os
/dev/sdb1            xfs     94G  5.3G   89G   6% /mysqldata


-- ALGORITHM=INPLACE
[115 sys@localhost 2017-05-22_17:26:09 (employees)]
SQL> select count(*) from emp2;          
+----------+
| count(*) |
+----------+
| 16801344 |
+----------+
1 row in set (8.60 sec)


[118 sys@localhost 2017-05-22_17:27:25 (employees)]
SQL> desc emp2;
+------------+---------------+------+-----+---------+-------+
| Field      | Type          | Null | Key | Default | Extra |
+------------+---------------+------+-----+---------+-------+
| emp_no     | int(11)       | NO   |     | NULL    |       |
| birth_date | date          | NO   |     | NULL    |       |
| first_name | varchar(14)   | NO   |     | NULL    |       |
| last_name  | varchar(16)   | NO   |     | NULL    |       |
| gender     | enum('M','F') | NO   |     | NULL    |       |
| hire_date  | date          | NO   |     | NULL    |       |
+------------+---------------+------+-----+---------+-------+
6 rows in set (0.00 sec)

[119 sys@localhost 2017-05-22_17:28:05 (employees)]
SQL> create index i_gender on emp2 (gender) ALGORITHM=INPLACE;
Query OK, 0 rows affected (30.37 sec)
Records: 0  Duplicates: 0  Warnings: 0

[120 sys@localhost 2017-05-22_17:30:08 (employees)]
SQL> show index from emp2;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| emp2  |          1 | i_gender |            1 | gender      | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
1 row in set (0.00 sec)



[123 sys@localhost 2017-05-22_17:32:42 (employees)]
SQL> drop index i_gender on emp2;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

[124 sys@localhost 2017-05-22_17:32:55 (employees)]
SQL> show index from emp2;
Empty set (0.00 sec)

[125 sys@localhost 2017-05-22_17:33:03 (employees)]
SQL> create index i_gender on emp2 (gender);                  
Query OK, 0 rows affected (31.51 sec)
Records: 0  Duplicates: 0  Warnings: 0

[127 sys@localhost 2017-05-22_17:34:05 (employees)]
SQL> show index from emp2;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| emp2  |          1 | i_gender |            1 | gender      | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
1 row in set (0.00 sec)




[127 sys@localhost 2017-05-22_17:34:05 (employees)]
SQL> show index from emp2;
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| emp2  |          1 | i_gender |            1 | gender      | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
1 row in set (0.00 sec)

[128 sys@localhost 2017-05-22_17:34:11 (employees)]
SQL> drop index i_gender on emp2;                  
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

[129 sys@localhost 2017-05-22_17:34:52 (employees)]
SQL> show index from emp2;       
Empty set (0.00 sec)

[130 sys@localhost 2017-05-22_17:34:56 (employees)]
SQL> create index i_gender on emp2 (gender) ALGORITHM=INPLACE;
Query OK, 0 rows affected (31.20 sec)
Records: 0  Duplicates: 0  Warnings: 0

[131 sys@localhost 2017-05-22_17:35:35 (employees)]
SQL> show index from emp2;                                    
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| emp2  |          1 | i_gender |            1 | gender      | A         |           1 |     NULL | NULL   |      | BTREE      |         |               |
+-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
1 row in set (0.00 sec)

[132 sys@localhost 2017-05-22_17:35:45 (employees)]
SQL> drop index i_gender on emp2;                                    
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

[133 sys@localhost 2017-05-22_17:35:49 (employees)]
SQL> show index from emp2;       
Empty set (0.00 sec)

[134 sys@localhost 2017-05-22_17:35:51 (employees)]
SQL> create index i_gender on emp2 (gender);                  
Query OK, 0 rows affected (30.61 sec)
Records: 0  Duplicates: 0  Warnings: 0





-- ALGORITHM=COPY
[135 sys@localhost 2017-05-22_17:36:26 (employees)]
SQL> select count(*) from emp2;
+----------+
| count(*) |
+----------+
| 16801344 |
+----------+
1 row in set (8.97 sec)

[136 sys@localhost 2017-05-22_17:38:20 (employees)]
SQL> drop index i_gender on emp2;                  
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

[137 sys@localhost 2017-05-22_17:39:06 (employees)]
SQL> create index i_gender on emp2 (gender) ALGORITHM=COPY;   
Query OK, 16801344 rows affected (1 min 41.34 sec)
Records: 16801344  Duplicates: 0  Warnings: 0
