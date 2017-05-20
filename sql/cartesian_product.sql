-- 笛卡尔乘积/笛卡尔积

-- https://zh.wikipedia.org/wiki/%E7%AC%9B%E5%8D%A1%E5%84%BF%E7%A7%AF

在数学中，两个集合X和Y的笛卡儿积（Cartesian product），又称直积，在集合论中表示为X × Y，是所有可能的有序对组成的集合，其中有序对的第一个对象是X的成员，第二个对象是Y的成员

{\displaystyle X\times Y=\left\{\left(x,y\right)\mid x\in X\land y\in Y\right\}}

-- 举个实例:
如果集合X是13个元素的点数集合{ A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2 }，而集合Y是4个元素的花色集合{♠, ♥, ♦, ♣}，
则这两个集合的笛卡儿积是有52个元素的标准扑克牌的集合{ (A, ♠), (K, ♠), ..., (2, ♠), (A, ♥), ..., (3, ♣), (2, ♣) }


-- 在SQL实例中形象查看
-- 2张表

[4 sys@localhost 2017-05-20_10:22:13 (test)]
SQL> select * from persons;
+------+----------+-----------+---------+------+
| Id_P | LastName | FirstName | Address | City |
+------+----------+-----------+---------+------+
|    1 | Adam     | John      | Oxfo    | Lond |
|    2 | Bush     | Geor      | Fift    | New  |
|    3 | Cart     | Thom      | Chan    | Beij |
+------+----------+-----------+---------+------+
3 rows in set (0.00 sec)

[5 sys@localhost 2017-05-20_10:34:58 (test)]
SQL> select * from orders; 
+------+---------+------+
| Id_O | OrderNo | Id_P |
+------+---------+------+
|    1 |   77895 |    3 |
|    2 |   44678 |    3 |
|    3 |   22456 |    1 |
|    4 |   24562 |    1 |
|    5 |   34764 |   65 |
+------+---------+------+
5 rows in set (0.00 sec)


左边的表或第1张表的每一行都会与第2张表的每一行乘积
1.persons x orders
[7 sys@localhost 2017-05-20_10:35:31 (test)]
SQL> select * from persons,orders;
+------+----------+-----------+---------+------+------+---------+------+
| Id_P | LastName | FirstName | Address | City | Id_O | OrderNo | Id_P |
+------+----------+-----------+---------+------+------+---------+------+
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |
+------+----------+-----------+---------+------+------+---------+------+
15 rows in set (0.00 sec)


2.orders x persons
[8 sys@localhost 2017-05-20_10:35:35 (test)]
SQL> select * from orders,persons;
+------+---------+------+------+----------+-----------+---------+------+
| Id_O | OrderNo | Id_P | Id_P | LastName | FirstName | Address | City |
+------+---------+------+------+----------+-----------+---------+------+
|    1 |   77895 |    3 |    1 | Adam     | John      | Oxfo    | Lond |
|    1 |   77895 |    3 |    2 | Bush     | Geor      | Fift    | New  |
|    1 |   77895 |    3 |    3 | Cart     | Thom      | Chan    | Beij |
|    2 |   44678 |    3 |    1 | Adam     | John      | Oxfo    | Lond |
|    2 |   44678 |    3 |    2 | Bush     | Geor      | Fift    | New  |
|    2 |   44678 |    3 |    3 | Cart     | Thom      | Chan    | Beij |
|    3 |   22456 |    1 |    1 | Adam     | John      | Oxfo    | Lond |
|    3 |   22456 |    1 |    2 | Bush     | Geor      | Fift    | New  |
|    3 |   22456 |    1 |    3 | Cart     | Thom      | Chan    | Beij |
|    4 |   24562 |    1 |    1 | Adam     | John      | Oxfo    | Lond |
|    4 |   24562 |    1 |    2 | Bush     | Geor      | Fift    | New  |
|    4 |   24562 |    1 |    3 | Cart     | Thom      | Chan    | Beij |
|    5 |   34764 |   65 |    1 | Adam     | John      | Oxfo    | Lond |
|    5 |   34764 |   65 |    2 | Bush     | Geor      | Fift    | New  |
|    5 |   34764 |   65 |    3 | Cart     | Thom      | Chan    | Beij |
+------+---------+------+------+----------+-----------+---------+------+
15 rows in set (0.00 sec)



-- 左边的表或第1张表的每一行都会与第2张表的每一行乘积,如果是多个表依次类推:

[13 sys@localhost 2017-05-20_10:40:23 (test)]
SQL> select * from t2_tmp_2_20170519;
+------+------+
| col1 | col2 |
+------+------+
|   25 |   83 |
|   29 |   97 |
|   14 |   86 |
|   46 |   84 |
|   34 |   90 |
|    4 |   90 |
+------+------+
6 rows in set (0.00 sec)


[14 sys@localhost 2017-05-20_10:40:37 (test)]
SQL> select * from persons,orders,t2_tmp_2_20170519;
+------+----------+-----------+---------+------+------+---------+------+------+------+
| Id_P | LastName | FirstName | Address | City | Id_O | OrderNo | Id_P | col1 | col2 |
+------+----------+-----------+---------+------+------+---------+------+------+------+
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |   25 |   83 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |   25 |   83 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |   25 |   83 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |   25 |   83 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |   25 |   83 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |   25 |   83 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |   25 |   83 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |   25 |   83 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |   25 |   83 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |   25 |   83 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |   25 |   83 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |   25 |   83 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |   25 |   83 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |   25 |   83 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |   25 |   83 |
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |   29 |   97 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |   29 |   97 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |   29 |   97 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |   29 |   97 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |   29 |   97 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |   29 |   97 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |   29 |   97 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |   29 |   97 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |   29 |   97 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |   29 |   97 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |   29 |   97 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |   29 |   97 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |   29 |   97 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |   29 |   97 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |   29 |   97 |
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |   14 |   86 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |   14 |   86 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |   14 |   86 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |   14 |   86 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |   14 |   86 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |   14 |   86 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |   14 |   86 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |   14 |   86 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |   14 |   86 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |   14 |   86 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |   14 |   86 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |   14 |   86 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |   14 |   86 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |   14 |   86 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |   14 |   86 |
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |   46 |   84 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |   46 |   84 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |   46 |   84 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |   46 |   84 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |   46 |   84 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |   46 |   84 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |   46 |   84 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |   46 |   84 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |   46 |   84 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |   46 |   84 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |   46 |   84 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |   46 |   84 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |   46 |   84 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |   46 |   84 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |   46 |   84 |
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |   34 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |   34 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |   34 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |   34 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |   34 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |   34 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |   34 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |   34 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |   34 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |   34 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |   34 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |   34 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |   34 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |   34 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |   34 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    1 |   77895 |    3 |    4 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    1 |   77895 |    3 |    4 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    1 |   77895 |    3 |    4 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    2 |   44678 |    3 |    4 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    2 |   44678 |    3 |    4 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    2 |   44678 |    3 |    4 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    3 |   22456 |    1 |    4 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    3 |   22456 |    1 |    4 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    3 |   22456 |    1 |    4 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    4 |   24562 |    1 |    4 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    4 |   24562 |    1 |    4 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    4 |   24562 |    1 |    4 |   90 |
|    1 | Adam     | John      | Oxfo    | Lond |    5 |   34764 |   65 |    4 |   90 |
|    2 | Bush     | Geor      | Fift    | New  |    5 |   34764 |   65 |    4 |   90 |
|    3 | Cart     | Thom      | Chan    | Beij |    5 |   34764 |   65 |    4 |   90 |
+------+----------+-----------+---------+------+------+---------+------+------+------+
90 rows in set (0.00 sec)
