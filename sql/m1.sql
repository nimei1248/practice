$ cat check_partition.sql
set session sql_log_bin=0;

use mysql;

drop procedure if exists check_partition;
delimiter //
create procedure check_partition()
BEGIN
        SELECT
                        CONCAT('show create table ', TABLE_SCHEMA, '.', TABLE_NAME, ';') into @a
                FROM
                        information_schema.PARTITIONS
                WHERE
                        (TABLE_SCHEMA NOT IN ('mysql' , 'sys', 'information_schema', 'performance_schema'))
                                AND (PARTITION_NAME IS NOT NULL
                                AND PARTITION_NAME <> 'p_nulls')
                GROUP BY table_name;

        select @a;

        prepare stmt17 from @a;
        execute stmt17;
        DEALLOCATE PREPARE stmt17;
END //
delimiter ;

call check_partition();
drop procedure if exists check_partition;

set session sql_log_bin=1;
