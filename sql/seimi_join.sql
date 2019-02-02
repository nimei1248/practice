mysql> show create table items;
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table
                                                                                          |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| items | CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `short_description` varchar(255) DEFAULT NULL,
  `description` text,
  `example` text,
  `explanation` text,
  `additional` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 |
+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> show create table items_links;
+-------------+---------------------------------------------------------------------------------------------------------------------------------+
| Table       | Create Table                                                                                                                    |
+-------------+---------------------------------------------------------------------------------------------------------------------------------+
| items_links | CREATE TABLE `items_links` (
  `iid` int(11) DEFAULT NULL,
  `linkid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
+-------------+---------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> select * from items;
+----+-------------------+-------------+---------+-------------+------------+
| id | short_description | description | example | explanation | additional |
+----+-------------------+-------------+---------+-------------+------------+
|  1 | aaaaa             | NULL        | NULL    | NULL        | NULL       |
|  2 | bbbbb             | NULL        | NULL    | NULL        | NULL       |
|  3 | ccccc             | NULL        | NULL    | NULL        | NULL       |
|  4 | ddddd             | NULL        | NULL    | NULL        | NULL       |
+----+-------------------+-------------+---------+-------------+------------+
4 rows in set (0.00 sec)


insert into items(id ,short_description) values(1,'aaaaa');
insert into items(id ,short_description) values(2,'bbbbb');
insert into items(id ,short_description) values(3,'ccccc');
insert into items(id ,short_description) values(4,'ddddd');


mysql> select * from items_links;
+------+--------+
| iid  | linkid |
+------+--------+
|    1 |      1 |
|    2 |      2 |
|    3 |      3 |
+------+--------+

insert into items_links values(1,1) ;
insert into items_links values(2,2) ;
insert into items_links values(3,3) ; 

3 rows in set (0.00 sec)

mysql> EXPLAIN SELECT COUNT(*) FROM items WHERE id IN (SELECT id FROM items_links) ;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                        |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+------------------------------+
|  1 | SIMPLE      | NULL  | NULL       | NULL | NULL          | NULL | NULL    | NULL | NULL |     NULL | Select tables optimized away |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+------------------------------+
1 row in set, 2 warnings (0.00 sec)

mysql> show warnings;
+-------+------+-----------------------------------------------------------------------------------------------------------+
| Level | Code | Message                                                                                                   |
+-------+------+-----------------------------------------------------------------------------------------------------------+
| Note  | 1276 | Field or reference 'test.items.id' of SELECT #2 was resolved in SELECT #1                                 |
| Note  | 1003 | /* select#1 */ select count(0) AS `COUNT(*)` from `test`.`items` semi join (`test`.`items_links`) where 1 |
+-------+------+-----------------------------------------------------------------------------------------------------------+
2 rows in set (0.00 sec)

mysql> EXPLAIN SELECT COUNT(*) FROM items WHERE id IN (SELECT iid FROM items_links) ;
+----+--------------+-------------+------------+--------+---------------+---------+---------+-----------------+------+----------+-------------+
| id | select_type  | table       | partitions | type   | possible_keys | key     | key_len | ref             | rows | filtered | Extra       |
+----+--------------+-------------+------------+--------+---------------+---------+---------+-----------------+------+----------+-------------+
|  1 | SIMPLE       | <subquery2> | NULL       | ALL    | NULL          | NULL    | NULL    | NULL            | NULL |   100.00 | Using where |
|  1 | SIMPLE       | items       | NULL       | eq_ref | PRIMARY       | PRIMARY | 4       | <subquery2>.iid |    1 |   100.00 | Using index |
|  2 | MATERIALIZED | items_links | NULL       | ALL    | NULL          | NULL    | NULL    | NULL            |    2 |   100.00 | NULL        |
+----+--------------+-------------+------------+--------+---------------+---------+---------+-----------------+------+----------+-------------+
3 rows in set, 1 warning (0.00 sec)

mysql> show warnings;
+-------+------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Level | Code | Message                                                                                                                                             |
+-------+------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Note  | 1003 | /* select#1 */ select count(0) AS `COUNT(*)` from `test`.`items` semi join (`test`.`items_links`) where (`test`.`items`.`id` = `<subquery2>`.`iid`) |
+-------+------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT COUNT(*) FROM items WHERE id IN (SELECT id FROM items_links ) ;
+----------+
| COUNT(*) |
+----------+
|       12 |
+----------+
1 row in set (0.00 sec)

mysql> SELECT COUNT(*) FROM items WHERE id IN (SELECT iid FROM items_links) ;
+----------+
| COUNT(*) |
+----------+
|        3 |
+----------+
1 row in set (0.00 sec)



SELECT COUNT(*) FROM items e WHERE id IN (SELECT id FROM items_links d ,(select @a:=0 rn ) c ) ;

mysql> show global variables like 'optimizer_switch';
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------+
| Variable_name    | Value

                                          |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------+
| optimizer_switch | index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------+
1 row in set, 1 warning (0.01 sec)


select count(1) from emp1 where emp_no in (select emp_no from departments)

