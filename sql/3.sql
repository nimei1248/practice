[32 sys@localhost 2017-05-22_10:59:50 (test)]
SQL> select 1 + 1;
+-------+
| 1 + 1 |
+-------+
|     2 |
+-------+
1 row in set (0.00 sec)

-- You are permitted to specify DUAL as a dummy table name in situations where no tables are referenced:
-- 在没有引用表的情况下，您可以将DUAL指定为虚拟表名
[33 sys@localhost 2017-05-22_10:59:55 (test)]
SQL> select 1 + 1 from dual;
+-------+
| 1 + 1 |
+-------+
|     2 |
+-------+
1 row in set (0.00 sec)


-- alias
[38 sys@localhost 2017-05-22_11:08:15 (test)]
SQL> select concat(orderno,'---->',id_p) from orders;
+------------------------------+
| concat(orderno,'---->',id_p) |
+------------------------------+
| 77895---->3                  |
| 44678---->3                  |
| 22456---->1                  |
| 24562---->1                  |
| 34764---->65                 |
+------------------------------+
5 rows in set (0.00 sec)

[39 sys@localhost 2017-05-22_11:08:26 (test)]
SQL> select concat(orderno,'---->',id_p) as xxx from orders;        
+--------------+
| xxx          |
+--------------+
| 77895---->3  |
| 44678---->3  |
| 22456---->1  |
| 24562---->1  |
| 34764---->65 |
+--------------+
5 rows in set (0.00 sec)


-- 字段别名及按别名排序
[40 sys@localhost 2017-05-22_11:11:00 (test)]
SQL> select * from persons;
+------+----------+-----------+---------+------+
| Id_P | LastName | FirstName | Address | City |
+------+----------+-----------+---------+------+
|    1 | Adam     | John      | Oxfo    | Lond |
|    2 | Bush     | Geor      | Fift    | New  |
|    3 | Cart     | Thom      | Chan    | Beij |
+------+----------+-----------+---------+------+
3 rows in set (0.00 sec)

[41 sys@localhost 2017-05-22_11:12:29 (test)]
SQL> select LastName,FirstName as f from persons order by f;
+----------+------+
| LastName | f    |
+----------+------+
| Bush     | Geor |
| Adam     | John |
| Cart     | Thom |
+----------+------+
3 rows in set (0.00 sec)


-- 按字段的位置排序
[42 sys@localhost 2017-05-22_11:13:07 (test)]
SQL> select LastName,FirstName as f from persons order by 2;
+----------+------+
| LastName | f    |
+----------+------+
| Bush     | Geor |
| Adam     | John |
| Cart     | Thom |
+----------+------+
3 rows in set (0.00 sec)

[43 sys@localhost 2017-05-22_11:14:13 (test)]
SQL> select LastName,FirstName as f from persons order by 1;
+----------+------+
| LastName | f    |
+----------+------+
| Adam     | John |
| Bush     | Geor |
| Cart     | Thom |
+----------+------+
3 rows in set (0.00 sec)



