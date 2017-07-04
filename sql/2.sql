select province,
application_system,
developer,
ip,
 SUM(CASE WHEN vulscan_host_leak_info.risk_score >= '7' THEN 1 ELSE 0 END) AS high,
 SUM(CASE WHEN (vulscan_host_leak_info.risk_score < '7' 
 AND vulscan_host_leak_info.risk_score >= '4') THEN 1 ELSE 0 END) AS middle,
 SUM(CASE WHEN vulscan_host_leak_info.risk_score < '4' THEN 1 ELSE 0 END) AS low 
from vulscan_host_leak_info 
group by 
province,
application_system,
developer,
ip
order by high desc, middle desc, low desc;
CREATE OR REPLACE VIEW 
    vulscan_host_leak_info AS 
    (
SELECT
    vulscan_host_leak_rel.id              AS vul_obj_id,
    vulscan_report_info.id                 AS report_info_id,
    vulscan_report_info.report_id          AS uuid,
    vulscan_report_info.province           AS province,
    vulscan_report_info.application_system AS application_system,
    vulscan_report_info.developer          AS developer,
    vulscan_report_info.update_time        AS update_time,
    vulscan_report_info.project_id         AS project_id,
    vulscan_report_info.account_id          AS account_id  ,
    vulscan_host.ip                        AS ip,
    vulscan_host.os                        AS os,
    vulscan_host_leak_rel.port             AS port,
    vulscan_host_leak_rel.protocol         AS protocol,
    vulscan_host_leak_rel.service          AS service,
    vulscan_leak.name                      AS vul_name,
    vulscan_leak.leak_type                 AS leak_type,
    vulscan_leak.risk_score                AS risk_score,
    vulscan_leak.solution                  AS solution,
    vulscan_leak.vul_id                    AS vul_id,
    vulscan_leak.application_category      AS application_category,
    vulscan_host_leak_rel.is_misjudge      AS is_misjudge 
FROM
    vulscan_report_info ,
     task_report_info, 
     vulscan_task_info,
     vulscan_host, 
     vulscan_host_leak_rel, 
     vulscan_leak
WHERE
    ((vulscan_report_info.is_delete = 0) AND
    (vulscan_report_info.id = task_report_info.report_info_id) AND
    (task_report_info.task_info_id = vulscan_task_info.id) AND
    (vulscan_task_info.id = vulscan_host.task_info_id) AND
    (vulscan_host.id = vulscan_host_leak_rel.host_id) AND
    (vulscan_host_leak_rel.leak_id = vulscan_leak.vul_id)));
+----+-------------+-----------------------+--------+-----------------+------------+---------+------------------------------------+------+----------------------------------------------+
| id | select_type | table                 | type   | possible_keys   | key        | key_len | ref                                | rows | Extra                                        |
+----+-------------+-----------------------+--------+-----------------+------------+---------+------------------------------------+------+----------------------------------------------+
|  1 | SIMPLE      | vulscan_report_info   | ALL    | PRIMARY,idx_7   | NULL       | NULL    | NULL                               |  484 | Using where; Using temporary; Using filesort |
|  1 | SIMPLE      | task_report_info      | ref    | idx_1,idx_2     | idx_1      | 9       | psso.vulscan_report_info.id        |    1 | Using where                                  |
|  1 | SIMPLE      | vulscan_task_info     | eq_ref | PRIMARY         | PRIMARY    | 8       | psso.task_report_info.task_info_id |    1 | Using index                                  |
|  1 | SIMPLE      | vulscan_host          | ref    | PRIMARY,idx_1   | idx_1      | 9       | psso.task_report_info.task_info_id |   16 | NULL                                         |
|  1 | SIMPLE      | vulscan_host_leak_rel | ref    | leak_id,host_id | host_id    | 9       | psso.vulscan_host.id               |   13 | Using where                                  |
|  1 | SIMPLE      | vulscan_leak          | ref    | idx_vul_id      | idx_vul_id | 5       | psso.vulscan_host_leak_rel.leak_id |    1 | Using index condition                        |

+----+-------------+-----------------------+--------+-----------------+------------+---------+------------------------------------+------+----------------------------------------------+
6 rows in set (0.00 sec)
这个sql 执行8秒多,怎么优化
...
