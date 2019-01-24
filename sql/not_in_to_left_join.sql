select t.emp_no ,s.emp_no from t_order t left join  (select emp_no from employees where emp_no > 20000) s
on t.emp_no=s.emp_no
where s.emp_no is null
and t.emp_no is not null


zst01@3306>[employees]>select * from t_order
    -> where emp_no not in (select emp_no from employees where emp_no > 20000);
+--------+---------+------------+------------+
| emp_no | dept_no | from_date  | to_date    |
+--------+---------+------------+------------+
|  10004 | d004    | 1986-12-01 | 9999-01-01 |
+--------+---------+------------+------------+
1 row in set (0.00 sec)

zst01@3306>[employees]>select t.emp_no ,s.emp_no from t_order t left join  (select emp_no from employees where emp_no > 20000) s
    -> on t.emp_no=s.emp_no;
+--------+--------+
| emp_no | emp_no |
+--------+--------+
|   NULL |   NULL |
|  10004 |   NULL |
|  22744 |  22744 |
|  24007 |  24007 |
|  30970 |  30970 |
|  31112 |  31112 |
|  40983 |  40983 |
|  48317 |  48317 |
|  49667 |  49667 |
|  50449 |  50449 |
+--------+--------+
10 rows in set (0.00 sec)

zst01@3306>[employees]>select t.emp_no ,s.emp_no from t_order t left join  (select emp_no from employees where emp_no > 20000) s
    -> on t.emp_no=s.emp_no
    -> where s.emp_no is null ;
+--------+--------+
| emp_no | emp_no |
+--------+--------+
|   NULL |   NULL |
|  10004 |   NULL |
+--------+--------+
2 rows in set (0.00 sec)

zst01@3306>[employees]>select t.emp_no ,s.emp_no from t_order t left join  (select emp_no from employees where emp_no > 20000) s
    -> on t.emp_no=s.emp_no
    -> where s.emp_no is null
    -> and t.emp_no is not null
    -> ;
+--------+--------+
| emp_no | emp_no |
+--------+--------+
|  10004 |   NULL |
+--------+--------+
1 row in set (0.00 sec)

zst01@3306>[employees]>

