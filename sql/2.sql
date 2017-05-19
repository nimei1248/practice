-- 目的: 对相同gid列的所有行,只取1行,条件是col2 > col1


-- 创建一个表
CREATE TABLE `t2` (
      `id` int(11) NOT NULL,
      `gid` char(1) COLLATE utf8_bin DEFAULT NULL,
      `col1` int(11) DEFAULT NULL,
      `col2` int(11) DEFAULT NULL,
      PRIMARY KEY (`id`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- 在表中插入数据
insert into t2 values
(1,'A',31,6),
(2,'B',25,83),
(3,'C',76,21),
(4,'D',63,56),
(5,'E',3,17), 
(6,'A',29,97),
(7,'B',88,63),
(8,'C',16,22),
(9,'D',25,43),
(10,'E',45,28),
(11,'A',2,78),
(12,'B',30,79),
(13,'C',96,73),
(14,'D',37,40),
(15,'E',14,86),
(16,'A',32,67),
(17,'B',84,38),
(18,'C',27,9),
(19,'D',31,21),
(20,'E',80,63),
(21,'A',89,9),
(22,'B',15,22),
(23,'C',46,84),
(24,'D',54,79),
(25,'E',85,64),
(26,'A',87,13),
(27,'B',40,45),
(28,'C',34,90),
(29,'D',63,8),
(30,'E',66,40),
(31,'A',83,49),
(32,'B',4,90),
(33,'C',81,7),
(34,'D',11,12),
(35,'E',85,10),
(36,'A',39,75),
(37,'B',22,39),
(38,'C',76,67),
(39,'D',20,11),
(40,'E',81,36);


-- 查看表中数据
[69 sys@localhost 2017-05-19_14:02:08 (test)]
SQL> select * from t2;
+----+------+------+------+
| id | gid  | col1 | col2 |
+----+------+------+------+
|  1 | A    |   31 |    6 |
|  2 | B    |   25 |   83 |
|  3 | C    |   76 |   21 |
|  4 | D    |   63 |   56 |
|  5 | E    |    3 |   17 |
|  6 | A    |   29 |   97 |
|  7 | B    |   88 |   63 |
|  8 | C    |   16 |   22 |
|  9 | D    |   25 |   43 |
| 10 | E    |   45 |   28 |
| 11 | A    |    2 |   78 |
| 12 | B    |   30 |   79 |
| 13 | C    |   96 |   73 |
| 14 | D    |   37 |   40 |
| 15 | E    |   14 |   86 |
| 16 | A    |   32 |   67 |
| 17 | B    |   84 |   38 |
| 18 | C    |   27 |    9 |
| 19 | D    |   31 |   21 |
| 20 | E    |   80 |   63 |
| 21 | A    |   89 |    9 |
| 22 | B    |   15 |   22 |
| 23 | C    |   46 |   84 |
| 24 | D    |   54 |   79 |
| 25 | E    |   85 |   64 |
| 26 | A    |   87 |   13 |
| 27 | B    |   40 |   45 |
| 28 | C    |   34 |   90 |
| 29 | D    |   63 |    8 |
| 30 | E    |   66 |   40 |
| 31 | A    |   83 |   49 |
| 32 | B    |    4 |   90 |
| 33 | C    |   81 |    7 |
| 34 | D    |   11 |   12 |
| 35 | E    |   85 |   10 |
| 36 | A    |   39 |   75 |
| 37 | B    |   22 |   39 |
| 38 | C    |   76 |   67 |
| 39 | D    |   20 |   11 |
| 40 | E    |   81 |   36 |
+----+------+------+------+
40 rows in set (0.00 sec)



-- 方法1
[80 sys@localhost 2017-05-19_14:12:23 (test)]
SQL> explain select * from t2 as a where not exists (select 1 from t2 where gid=a.gid and col2 > a.col2) order by gid;
+----+--------------------+-------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
| id | select_type        | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                       |
+----+--------------------+-------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
|  1 | PRIMARY            | a     | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   40 |   100.00 | Using where; Using filesort |
|  2 | DEPENDENT SUBQUERY | t2    | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   40 |     3.33 | Using where                 |
+----+--------------------+-------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
2 rows in set, 3 warnings (0.00 sec)


-- gid列相同的情况下,比较col2获取最大的col2(此时通过隐士循环获取最大值)
[79 sys@localhost 2017-05-19_14:12:06 (test)]
SQL> select * from t2 as a where not exists (select 1 from t2 where gid=a.gid and col2 > a.col2) order by gid;
+----+------+------+------+
| id | gid  | col1 | col2 |
+----+------+------+------+
|  6 | A    |   29 |   97 |
| 32 | B    |    4 |   90 |
| 28 | C    |   34 |   90 |
| 24 | D    |   54 |   79 |
| 15 | E    |   14 |   86 |
+----+------+------+------+
5 rows in set (0.00 sec)

-- 解释:
-- 1.select 1 from t2 where gid=a.gid and col2 > a.col2 (select就进入了隐式迭代,同组中比当前col2大的就输出1)
-- 2.然后not exists来判断是否存在比当前col2大的,如果不存在就返回true;返回true就输出当前col2这一列
-- 3.这里的exists与not exists是判断语句,返回的是true or false


-- 方法2
-- 使用group by的去重分组 and max()函数取出最大值,这里只能获取指定列的信息
[121 sys@localhost 2017-05-19_14:59:44 (test)]
SQL> select gid, max(col2) from t2 group by gid;
+------+-----------+
| gid  | max(col2) |
+------+-----------+
| A    |        97 |
| B    |        90 |
| C    |        90 |
| D    |        79 |
| E    |        86 |
+------+-----------+
5 rows in set (0.00 sec)


-- 通过in获取符合条件的所有列信息
[117 sys@localhost 2017-05-19_14:54:11 (test)]
SQL> select * from t2 where (gid,col2) in (select gid, max(col2) from t2 group by gid) order by gid;
+----+------+------+------+
| id | gid  | col1 | col2 |
+----+------+------+------+
|  6 | A    |   29 |   97 |
| 32 | B    |    4 |   90 |
| 28 | C    |   34 |   90 |
| 24 | D    |   54 |   79 |
| 15 | E    |   14 |   86 |
+----+------+------+------+
5 rows in set (0.00 sec)


-- 方法3
[158 sys@localhost 2017-05-19_15:43:06 (test)]
SQL> select * from t2 as a where 1 > (select count(*) from t2 where gid = a.gid and col2 > a.col2) order by a.gid, a.col2 desc;
+----+------+------+------+
| id | gid  | col1 | col2 |
+----+------+------+------+
|  6 | A    |   29 |   97 |
| 32 | B    |    4 |   90 |
| 28 | C    |   34 |   90 |
| 24 | D    |   54 |   79 |
| 15 | E    |   14 |   86 |
+----+------+------+------+
5 rows in set (0.00 sec)


select * from t2 as a where not exists (select 1 from t2 where gid=a.gid and col2 > a.col2) order by gid;
select * from t2 where (gid,col2) in (select gid, max(col2) from t2 group by gid) order by gid;
select * from t2 as a where 1 > (select count(*) from t2 where gid = a.gid and col2 > a.col2) order by a.gid, a.col2 desc;
-- 上面两条自连接sql都比较难理解,但只要换个角度,其实理解起来也很容易:
-- 首先在mysql中要把select翻译为输出,并且要满足where以后才输出;输出以后再分组,分组以后才轮到排序,排序之后才轮到取几个


-- 总结:
-- 1.将杂乱的数据排序
-- 2.满足where条件
-- 3.group by做分组
-- 4.order by做排序



-- join
-- join 用于根据两个或多个表中的列之间的关系，从这些表中查询数据

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


-- Join 和 Key:
-- 有时为了得到完整的结果，我们需要从两个或更多的表中获取结果。我们就需要执行 join
-- 数据库中的表可通过键将彼此联系起来。主键（Primary Key）是一个列，在这个列中的每一行的值都是唯一的
-- 在表中，每个主键的值都是唯一的。这样做的目的是在不重复每个表中的所有数据的情况下，把表间的数据交叉捆绑在一起


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
