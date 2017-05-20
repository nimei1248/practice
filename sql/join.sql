-- join 
-- 作用: 用于根据两个或多个表中的列之间的关系，从这些表中查询数据


join and key:
-- 1.当需要从2个或多个表中获取结果,就需要join
-- 2.数据库中的表可通过键将彼此联系起来。主键是一个列,这个列中的每一行的值都是唯一的
-- 3.在表中每个主键的值是唯一的，这样做的目的:是在不重复每个表中的所有数据的情况下,把表间的数据交叉捆绑在一起


-- help join:
SELECT * FROM t1 LEFT JOIN (t2, t3, t4)
                 ON (t2.a=t1.a AND t3.b=t1.b AND t4.c=t1.c)

-- is equivalent to:

SELECT * FROM t1 LEFT JOIN (t2 CROSS JOIN t3 CROSS JOIN t4)
                 ON (t2.a=t1.a AND t3.b=t1.b AND t4.c=t1.c)

-- URL: http://dev.mysql.com/doc/refman/5.7/en/join.html

-- Examples:
SELECT left_tbl.*
  FROM left_tbl LEFT JOIN right_tbl ON left_tbl.id = right_tbl.id
  WHERE right_tbl.id IS NULL;


-- http://www.cnblogs.com/nixi8/p/4474234.html

--  http://dev.mysql.com/doc/refman/5.7/en/join.html
-- join_table:
--     table_reference [INNER | CROSS] JOIN table_factor [join_condition]
--     table_reference STRAIGHT_JOIN table_factor
--     table_reference STRAIGHT_JOIN table_factor ON conditional_expr
--     table_reference {LEFT|RIGHT} [OUTER] JOIN table_reference join_condition
--     table_reference NATURAL [{LEFT|RIGHT} [OUTER]] JOIN table_factor


-- JOIN 类型及它们之间的差异:
--     JOIN=inner join: 如果表中有至少一个匹配，则返回行  即,等值连接
--     LEFT JOIN:  即使右表中没有匹配，也从左表返回所有的行
--     RIGHT JOIN: 即使左表中没有匹配，也从右表返回所有的行
--     FULL JOIN:  只要其中一个表中存在匹配，就返回行


-- 创建测试表
CREATE TABLE Persons (
    Id_P INT AUTO_INCREMENT NOT NULL,
    LastName VARCHAR(4) NOT NULL,
    FirstName VARCHAR(4) NOT NULL,
    Address VARCHAR(4) NOT NULL,
    City VARCHAR(4) NOT NULL,
    PRIMARY KEY (Id_P)
);


CREATE TABLE Orders (
    Id_O INT AUTO_INCREMENT NOT NULL,
    OrderNo INT NOT NULL,
    Id_P INT NOT NULL,
    PRIMARY KEY (Id_O)
);


-- 插入数据
insert into Persons (LastName,FirstName,Address,City) values
('Adams','John','Oxford Street','London'),
('Bush','George','Fifth Avenue','New York'),
('Carter','Thomas','Changan Street','Beijing');

insert into Orders (OrderNo,Id_P) values
(77895,3),
(44678,3),
(22456,1),
(24562,1),
(34764,65);


-- 引用2个表：
-- 通过引用两个表的方式，从两个表中获取数据
-- 谁订购了产品，并且他们订购了什么产品？

[285 sys@localhost 2017-05-19_18:08:53 (test)]
SQL> select * from Persons;
+------+----------+-----------+---------+------+
| Id_P | LastName | FirstName | Address | City |
+------+----------+-----------+---------+------+
|    1 | Adam    | John      | Oxfo    | Lond |
|    2 | Bush    | Geor      | Fift    | New  |
|    3 | Cart    | Thom      | Chan    | Beij |
+------+----------+-----------+---------+------+
3 rows in set (0.00 sec)

[286 sys@localhost 2017-05-19_18:09:51 (test)]
SQL> select * from Orders;
+------+---------+------+
| Id_O | OrderNo | Id_P |
+------+---------+------+
|    1 |  77895 |    3 |
|    2 |  44678 |    3 |
|    3 |  22456 |    1 |
|    4 |  24562 |    1 |
|    5 |  34764 |  65 |
+------+---------+------+
5 rows in set (0.00 sec)

[287 sys@localhost 2017-05-19_18:09:55 (test)]
SQL> select L.LastName, L.FirstName, R.OrderNo from Persons as L, Orders as R where L.Id_P = R.Id_P;
+----------+-----------+---------+
| LastName | FirstName | OrderNo |
+----------+-----------+---------+
| Cart    | Thom      |  77895 |
| Cart    | Thom      |  44678 |
| Adam    | John      |  22456 |
| Adam    | John      |  24562 |
+----------+-----------+---------+
4 rows in set (0.00 sec)


[288 sys@localhost 2017-05-19_18:11:54 (test)]
SQL> select L.LastName, L.FirstName, R.OrderNo from Persons as L, Orders as R where L.Id_P = R.Id_P order by L.LastName;
+----------+-----------+---------+
| LastName | FirstName | OrderNo |
+----------+-----------+---------+
| Adam    | John      |  22456 |
| Adam    | John      |  24562 |
| Cart    | Thom      |  77895 |
| Cart    | Thom      |  44678 |
+----------+-----------+---------+
4 rows in set (0.00 sec)


-- SQL JOIN - 使用 Join:
-- 除了上面的方法，我们也可以使用关键词 JOIN 来从两个表中获取数据。
-- 如果我们希望列出所有人的定购，可以使用下面的 SELECT 语句：

[289 sys@localhost 2017-05-19_18:14:23 (test)]
SQL> select L.LastName, L.FirstName, R.OrderNo from Persons as L inner join Orders as R on L.Id_P = R.Id_P order by L.LastName;     
+----------+-----------+---------+
| LastName | FirstName | OrderNo |
+----------+-----------+---------+
| Adam    | John      |  22456 |
| Adam    | John      |  24562 |
| Cart    | Thom      |  77895 |
| Cart    | Thom      |  44678 |
+----------+-----------+---------+
4 rows in set (0.00 sec)


[22 sys@localhost 2017-05-20_11:36:08 (test)]
SQL> select L.LastName, L.FirstName, R.OrderNo from persons as L join orders as R on L.Id_P = R.Id_P order by LastName;      
+----------+-----------+---------+
| LastName | FirstName | OrderNo |
+----------+-----------+---------+
| Adam     | John      |   22456 |
| Adam     | John      |   24562 |
| Cart     | Thom      |   77895 |
| Cart     | Thom      |   44678 |
+----------+-----------+---------+
4 rows in set (0.00 sec)


-- 对比写法：
select L.LastName, L.FirstName, R.OrderNo from Persons as L, Orders as R where L.Id_P = R.Id_P order by L.LastName;
select L.LastName, L.FirstName, R.OrderNo from Persons as L inner join Orders as R on L.Id_P = R.Id_P order by L.LastName;       
-- 1., ---> inner join
-- 2.where ---> on


-- inner join 内连接
-- INNER JOIN 关键字在表中存在至少一个匹配时返回行。如果 "Persons" 中的行在 "Orders" 中没有匹配，就不会列出这些行


-- LEFT JOIN 左连接
-- LEFT JOIN 关键字会从左表 (table_name1) 那里返回所有的行，即使在右表 (table_name2) 中没有匹配的行
-- 注释：在某些数据库中， LEFT JOIN 称为 LEFT OUTER JOIN

-- 列出所有的人，以及他们的定购 - 如果有的话
[18 sys@localhost 2017-05-19_18:50:54 (test)]
SQL> select * from Persons;
+------+----------+-----------+---------+------+
| Id_P | LastName | FirstName | Address | City |
+------+----------+-----------+---------+------+
|    1 | Adam     | John      | Oxfo    | Lond |
|    2 | Bush     | Geor      | Fift    | New  |
|    3 | Cart     | Thom      | Chan    | Beij |
+------+----------+-----------+---------+------+
3 rows in set (0.00 sec)

[19 sys@localhost 2017-05-19_18:57:24 (test)]
SQL> select * from Orders; 
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

[20 sys@localhost 2017-05-19_18:57:30 (test)]
SQL> select L.LastName, L.FirstName, R.OrderNo from Persons as L left join Orders as R on L.Id_P = R.Id_P order by L.LastName;
+----------+-----------+---------+
| LastName | FirstName | OrderNo |
+----------+-----------+---------+
| Adam     | John      |   22456 |
| Adam     | John      |   24562 |
| Bush     | Geor      |    NULL |
| Cart     | Thom      |   77895 |
| Cart     | Thom      |   44678 |
+----------+-----------+---------+
5 rows in set (0.00 sec)

-- LEFT JOIN 关键字会从左表 (Persons) 那里返回所有的行，即使在右表 (Orders) 中没有匹配的行




-- RIGHT JOIN 右连接
-- RIGHT JOIN 关键字会右表 (table_name2) 那里返回所有的行，即使在左表 (table_name1) 中没有匹配的行
-- 注释：在某些数据库中， RIGHT JOIN 称为 RIGHT OUTER JOIN。

-- 列出所有的定单，以及定购它们的人 - 如果有的话
[21 sys@localhost 2017-05-19_18:57:33 (test)]
SQL> select L.LastName, L.FirstName, R.OrderNo from Persons as L right join Orders as R on L.Id_P = R.Id_P order by L.LastName;         
+----------+-----------+---------+
| LastName | FirstName | OrderNo |
+----------+-----------+---------+
| NULL     | NULL      |   34764 |
| Adam     | John      |   22456 |
| Adam     | John      |   24562 |
| Cart     | Thom      |   77895 |
| Cart     | Thom      |   44678 |
+----------+-----------+---------+
5 rows in set (0.00 sec)

-- RIGHT JOIN 关键字会从右表 (Orders) 那里返回所有的行，即使在左表 (Persons) 中没有匹配的行



总结:
    1.left join  左表指定的列都会显示,右表没有匹配的就用NULL替代
    2.right join 右表指定的列都会显示,左表没有匹配的就用NULL替代


