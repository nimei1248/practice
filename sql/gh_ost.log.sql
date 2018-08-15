$ time ./gh-ost \
> --host=127.0.0.1 \
> --port=3309 \
> --user=root \
> --password=abc \
> --database=db1 \
> --table=t1 \
> --max-load='Threads_running=100,threads_connected=100' \
> --critical-load='Threads_running=120,threads_connected=120' \
> --assume-rbr \
> --cut-over=atomic \
> --timestamp-old-table \
> --exact-rowcount \
> --concurrent-rowcount \
> --default-retries=120 \
> --approve-renamed-columns \
> --verbose \
> --debug \
> --panic-flag-file=/tmp/gh-ost.panic.flag \
> --postpone-cut-over-flag-file=/tmp/gh-ost.postpone.flag \
> --dml-batch-size=30 \
> --chunk-size=2000 \
> --allow-on-master \
> --allow-master-master \
> --alter 'modify c2 varchar(150) NOT NULL DEFAULT "xx"' \
> --execute
2018-08-08 16:52:24 INFO starting gh-ost 1.0.46
开始运行gh-ost 版本1.0.46

2018-08-08 16:52:24 INFO Migrating `db1`.`t1`
迁移db1.t1表

2018-08-08 16:52:24 INFO connection validated on 127.0.0.1:3309
连接验证

2018-08-08 16:52:24 INFO User has ALL privileges
操作用户有所有权限

2018-08-08 16:52:24 INFO binary logs validated on 127.0.0.1:3309
binary log验证

2018-08-08 16:52:24 INFO Inspector initiated on dbhost:3309, version 5.7.19-17-log
在主机上启动检测程序

2018-08-08 16:52:24 INFO Table found. Engine=InnoDB
发现innodb表

2018-08-08 16:52:24 DEBUG Estimated number of rows via STATUS: 9684915
通过状态估计的行数: 9684915
show table status like 't1'\G

2018-08-08 16:52:24 DEBUG Validated no foreign keys exist on table
表上不存在外键

2018-08-08 16:52:24 DEBUG Validated no triggers exist on table
表上不存在触发器

2018-08-08 16:52:24 INFO Estimated number of rows via EXPLAIN: 9684915
通过explain预估行数: 9684915
desc select count(*) from t1;

2018-08-08 16:52:24 DEBUG Potential unique keys in t1: [PRIMARY (auto_increment): [id]; has nullable: false]
t1表中潜在的UK: [id 自增; not null]

2018-08-08 16:52:24 INFO Recursively searching for replication master
递归搜索复制master

2018-08-08 16:52:24 DEBUG Looking for master on 127.0.0.1:3309
在实例上搜索master

2018-08-08 16:52:24 INFO Master found to be dbhost:3309
在dbhost:3309主机上发现master

2018-08-08 16:52:24 INFO log_slave_updates validated on 127.0.0.1:3309
在实例上验证参数log_slave_updates

2018-08-08 16:52:24 INFO connection validated on 127.0.0.1:3309
连接验证

2018-08-08 16:52:24 DEBUG Streamer binlog coordinates: mysql-bin.000014:7360
binlog坐标

2018/08/08 16:52:24 binlogsyncer.go:79: [info] create BinlogSyncer with config {99999 mysql 127.0.0.1 3309 root   false false <nil>}
使用{99999 mysql 127.0.0.1 3309 root   false false <nil>}创建二进制同步程序BinlogSyncer

2018-08-08 16:52:24 INFO Connecting binlog streamer at mysql-bin.000014:7360
连接binlog流坐标

2018/08/08 16:52:24 binlogsyncer.go:246: [info] begin to sync binlog from position (mysql-bin.000014, 7360)
开始同步binlog坐标

2018/08/08 16:52:24 binlogsyncer.go:139: [info] register slave for master server 127.0.0.1:3309
注释slave到master 127.0.0.1:3309

2018/08/08 16:52:24 binlogsyncer.go:573: [info] rotate to (mysql-bin.000014, 7360)
轮流到二进制日志坐标

2018-08-08 16:52:24 DEBUG Beginning streaming
开始进行二进制流操作

2018-08-08 16:52:24 INFO rotate to next log name: mysql-bin.000014
轮流到下一个binary log name

2018-08-08 16:52:24 INFO connection validated on 127.0.0.1:3309
2018-08-08 16:52:24 INFO connection validated on 127.0.0.1:3309
连接验证

2018-08-08 16:52:24 INFO will use time_zone='SYSTEM' on applier
在slave上使用的时区

2018-08-08 16:52:24 INFO Examining table structure on applier
在slave上检查表结构

2018-08-08 16:52:24 INFO Applier initiated on dbhost:3309, version 5.7.19-17-log
slave启动在主机dbhost:3309

2018-08-08 16:52:24 INFO Dropping table `db1`.`_t1_ghc`
2018-08-08 16:52:24 INFO Table dropped
删除进度表

2018-08-08 16:52:24 INFO Creating changelog table `db1`.`_t1_ghc`
2018-08-08 16:52:24 INFO Changelog table created
创建进度表

2018-08-08 16:52:24 INFO Creating ghost table `db1`.`_t1_gho`
2018-08-08 16:52:24 INFO Ghost table created
创建ghost表

2018-08-08 16:52:24 INFO Altering ghost table `db1`.`_t1_gho`
2018-08-08 16:52:24 DEBUG ALTER statement: alter /* gh-ost */ table `db1`.`_t1_gho` modify c2 varchar(150) NOT NULL DEFAULT "xx"
2018-08-08 16:52:24 INFO Ghost table altered
修改ghost表结构

2018-08-08 16:52:24 INFO Intercepted changelog state GhostTableMigrated
拦截进度表中的GhostTableMigrated状态

2018-08-08 16:52:24 INFO Waiting for ghost table to be migrated. Current lag is 0s
等待ghost表被迁移，当前延迟0s

2018-08-08 16:52:24 DEBUG ghost table migrated
ghost表开始迁移

2018-08-08 16:52:24 INFO Handled changelog state GhostTableMigrated
处理进度表中GhostTableMigrated状态

2018-08-08 16:52:24 DEBUG Potential unique keys in _t1_gho: [PRIMARY (auto_increment): [id]; has nullable: false]
_t1_gho表中潜在的UK[自增id; NOT NULL]

2018-08-08 16:52:24 INFO Chosen shared unique key is PRIMARY
选择共享UK is PK

2018-08-08 16:52:24 INFO Shared columns are id,name,c1,c2,c30,c3
共享列是id,name,c1,c2,c30,c3

2018-08-08 16:52:24 INFO Listening on unix socket file: /tmp/gh-ost.db1.t1.sock
监听套接字

2018-08-08 16:52:24 INFO As instructed, counting rows in the background; meanwhile I will use an estimated count, and will update it later on
按照参数指示，在后台计算行数; 同时我将使用估计的数量，并将在稍后更新
即,先安装预估的行数进行迁移，在迁移的过程中后台统计行数，然后再更新成正确的行数

2018-08-08 16:52:24 DEBUG Reading migration range according to key: PRIMARY
根据PK读取迁移的范围

2018-08-08 16:52:24 INFO As instructed, I'm issuing a SELECT COUNT(*) on the table. This may take a while
根据参数指示，我将在t1表发起select count(*) from t1; 这可能还要等一下

2018-08-08 16:52:24 INFO Migration min values: [90011]
迁移范围的最小值

2018-08-08 16:52:24 DEBUG Reading migration range according to key: PRIMARY
根据PK读取迁移范围

2018-08-08 16:52:24 INFO Migration max values: [13303956]
迁移范围的最大值

2018-08-08 16:52:24 INFO Waiting for first throttle metrics to be collected
等待第一个限制/节流指标被收集

2018-08-08 16:52:24 INFO First throttle metrics collected
第一个限制/节流指标被收集

2018-08-08 16:52:24 DEBUG Operating until row copy is complete
操作直到row-copy完成(迁移频率确认、节流/限制指标收集)

每隔10分钟，会打印一份友好提醒，格式如下：
# Migrating `db1`.`t1`; Ghost table is `db1`.`_t1_gho`
2018-08-08 16:52:24 DEBUG Getting nothing in the write queue. Sleeping...
# Migrating dbhost:3309; inspecting dbhost:3309; executing on dbhost
# Migration started at Wed Aug 08 16:52:24 +0800 2018
# chunk-size: 2000; max-lag-millis: 1500ms; dml-batch-size: 30; max-load: Threads_running=100,threads_connected=100; critical-load: Threads_running=120,threads_connected=120; nice-ratio: 0.000000
# throttle-additional-flag-file: /tmp/gh-ost.throttle 
# postpone-cut-over-flag-file: /tmp/gh-ost.postpone.flag [set]
# panic-flag-file: /tmp/gh-ost.panic.flag
# Serving on unix socket: /tmp/gh-ost.db1.t1.sock

Copy: 0/9684915 0.0%; Applied: 0; Backlog: 0/1000; Time: 0s(total), 0s(copy); streamer: mysql-bin.000014:9989; State: migrating; ETA: N/A
Copy: 0/9684915 0.0%; Applied: 0; Backlog: 0/1000; Time: 1s(total), 1s(copy); streamer: mysql-bin.000014:16826; State: migrating; ETA: N/A
Copy: 0/9684915 0.0%; 表示复制到ghost表中的现有表行数，而不是表的总行数的估计值

Copy: 31291200/43138418, Copy: 31389700/43138432: this migration executed with --exact-rowcount. gh-ost continuously heuristically updates the total number of expected row copies as migration proceeds, hence the change from 43138418 to 43138432
使用--exact-rowcount执行此迁移。当迁移进行时，gh-ost持续启发式更新预期行副本的总数，因此从43138418更改为43138432

Applied: 0; 表示在二进制日志中处理并应用于ghost表的条目数。在上面的示例中，迁移的表上没有流量，因此没有处理任何行
Applied: 100: 表示自迁移开始以来，处理迁移表的更改的二进制日志中的100个事件已处理并应用于ghost表

Backlog: 0/1000; 在读取二进制日志时表现良好。二进制日志队列中没有任何已知的等待处理的事件
Backlog: 7/100: while copying rows, a few events have piled up in the binary log modifying our table that we spotted, and still need to apply.
在复制行时，在二进制日志中堆积了一些事件，修改了我们发现的表，并且仍然需要应用

Backlog: 100/100: our buffer of 100 events is full; you may see this during or right after throttling (the binary logs keep filling up with relevant queries that are not being processed), or immediately following a high workload. gh-ost will always prioritize binlog event processing (backlog) over row-copy; when next possible (throttling completes, in our example), gh-ost will drain the queue first, and only then proceed to resume row copy. There is nothing wrong with seeing 100/100; it just indicates we're behind at that point in time
我们100个事件的缓冲区已满;你可能会在限制期间或之后看到这种情况（二进制日志会不断填写未处理的相关查询），或者在高工作负载之后立即看到。gh-ost总是优先考虑binlog事件处理（backlog）而不是row-copy;当下一次可能时（节流完成，在我们的例子中），gh-ost将首先排空队列，然后才继续恢复行复制。看到100/100没有错;它只是表明我们在那个时间点落后了

Time: 1s(total), 1s(copy);
在实际的行复制开始之前已经过了1s

streamer: mysql-bin.000014:16826;
告诉我们此时哪个二进制日志条目在gh-ost处理

State: migrating; 
此时状态是migrating

ETA: N/A
gh-ost在完成1％的复制之前不会提供ETA

下面开始真正的row-copy:
从90011开始，按2000行频率，持续迭代，将原表数据插入ghost表
2018-08-08 16:52:25 DEBUG Issued INSERT on range: [90011]..[92010]; iteration: 0; chunk-size: 2000
2018-08-08 16:52:25 DEBUG Issued INSERT on range: [92010]..[94010]; iteration: 1; chunk-size: 2000
2018-08-08 16:52:25 DEBUG Issued INSERT on range: [94010]..[96010]; iteration: 2; chunk-size: 2000
2018-08-08 16:52:25 DEBUG Issued INSERT on range: [96010]..[98010]; iteration: 3; chunk-size: 2000
2018-08-08 16:52:25 DEBUG Issued INSERT on range: [98010]..[100010]; iteration: 4; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [100010]..[102010]; iteration: 5; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [102010]..[104010]; iteration: 6; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [104010]..[106010]; iteration: 7; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [106010]..[132585]; iteration: 8; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [132585]..[134585]; iteration: 9; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [134585]..[136585]; iteration: 10; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [136585]..[138585]; iteration: 11; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [138585]..[140585]; iteration: 12; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [140585]..[142585]; iteration: 13; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [142585]..[144585]; iteration: 14; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [144585]..[146585]; iteration: 15; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [146585]..[148585]; iteration: 16; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [148585]..[150585]; iteration: 17; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [150585]..[152585]; iteration: 18; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [152585]..[154585]; iteration: 19; chunk-size: 2000
Copy: 40000/9684915 0.4%; Applied: 0; Backlog: 0/1000; Time: 2s(total), 2s(copy); streamer: mysql-bin.000014:1039124; State: migrating; ETA: N/A
上面row-copy 20次 每次2000 这里显示的是40000，表示复制到ghost表中的现有表行数，占比0.4%
Time: 2s(total), 2s(copy); 减去正式复制前1秒，上面操作耗时1秒
streamer: mysql-bin.000014:1039124; 此时binlog流坐标

2018-08-08 16:52:26 DEBUG Issued INSERT on range: [154585]..[156585]; iteration: 20; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [156585]..[158585]; iteration: 21; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [158585]..[160585]; iteration: 22; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [160585]..[162585]; iteration: 23; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [162585]..[164585]; iteration: 24; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [164585]..[166585]; iteration: 25; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [166585]..[168585]; iteration: 26; chunk-size: 2000
2018-08-08 16:52:26 DEBUG Issued INSERT on range: [168585]..[170585]; iteration: 27; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [170585]..[172585]; iteration: 28; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [172585]..[174585]; iteration: 29; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [174585]..[176585]; iteration: 30; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [176585]..[178585]; iteration: 31; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [178585]..[180585]; iteration: 32; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [180585]..[182585]; iteration: 33; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [182585]..[184585]; iteration: 34; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [184585]..[186585]; iteration: 35; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [186585]..[188585]; iteration: 36; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [188585]..[190585]; iteration: 37; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [190585]..[192585]; iteration: 38; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [192585]..[194585]; iteration: 39; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [194585]..[196585]; iteration: 40; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [196585]..[198585]; iteration: 41; chunk-size: 2000
2018-08-08 16:52:27 DEBUG Issued INSERT on range: [198585]..[200585]; iteration: 42; chunk-size: 2000
Copy: 86000/9684915 0.9%; Applied: 0; Backlog: 0/1000; Time: 3s(total), 3s(copy); streamer: mysql-bin.000014:2213730; State: migrating; ETA: N/A
同上
..........................................................................................................
省略

2018-08-08 16:52:32 DEBUG Issued INSERT on range: [524500]..[526500]; iteration: 164; chunk-size: 2000
2018-08-08 16:52:32 DEBUG Issued INSERT on range: [526500]..[528500]; iteration: 165; chunk-size: 2000
2018-08-08 16:52:32 DEBUG Issued INSERT on range: [528500]..[530500]; iteration: 166; chunk-size: 2000
2018-08-08 16:52:32 INFO Exact number of rows via COUNT: 10354930
通过计算确切的行数: 10354930
..........................................................................................................
省略

Copy: 1644000/10354930 15.9%; Applied: 0; Backlog: 0/1000; Time: 30s(total), 30s(copy); streamer: mysql-bin.000014:39811943; State: migrating; ETA: 2m38s
ETA: 2m38s
..........................................................................................................
省略

Copy: 3620000/10354930 35.0%; Applied: 0; Backlog: 0/1000; Time: 59s(total), 59s(copy); streamer: mysql-bin.000014:84182410; State: migrating; ETA: 1m49s
ETA: 1m49s
..........................................................................................................
省略

2018-08-08 16:53:23 DEBUG Issued INSERT on range: [5027563]..[5031563]; iteration: 1814; chunk-size: 2000
2018-08-08 16:53:23 DEBUG Issued INSERT on range: [5031563]..[5035563]; iteration: 1815; chunk-size: 2000
2018-08-08 16:53:23 DEBUG ApplyDMLEventQueries() applied 1 events in one transaction
在一个事务中应用一个事件，说明有对原表做了一个事务
..........................................................................................................
省略

2018-08-08 16:53:35 DEBUG Issued INSERT on range: [6679563]..[6683563]; iteration: 2227; chunk-size: 2000
2018-08-08 16:53:35 DEBUG Issued INSERT on range: [6683563]..[6687563]; iteration: 2228; chunk-size: 2000
2018-08-08 16:53:35 DEBUG ApplyDMLEventQueries() applied 1 events in one transaction
同上
..........................................................................................................
省略

2018-08-08 16:54:07 DEBUG Issued INSERT on range: [9519026]..[9521026]; iteration: 3285; chunk-size: 2000
Copy: 6572000/10354932 63.5%; Applied: 2; Backlog: 0/1000; Time: 1m43s(total), 1m43s(copy); streamer: mysql-bin.000014:153354800; State: migrating; ETA: 59s
ETA: 59s
..........................................................................................................
省略

2018-08-08 16:54:08 DEBUG Issued INSERT on range: [9589026]..[9591026]; iteration: 3320; chunk-size: 2000
Copy: 6642000/10354932 64.1%; Applied: 2; Backlog: 0/1000; Time: 1m44s(total), 1m44s(copy); streamer: mysql-bin.000014:154927114; State: migrating; ETA: 58s
..........................................................................................................
省略

2018-08-08 16:54:45 DEBUG Issued INSERT on range: [12023026]..[12025026]; iteration: 4537; chunk-size: 2000
2018-08-08 16:54:45 DEBUG Issued INSERT on range: [12025026]..[12027026]; iteration: 4538; chunk-size: 2000
2018/08/08 16:54:45 binlogsyncer.go:573: [info] rotate to (mysql-bin.000015, 4)
2018/08/08 16:54:45 binlogsyncer.go:573: [info] rotate to (mysql-bin.000015, 4)
2018-08-08 16:54:45 INFO rotate to next log name: mysql-bin.000015
2018-08-08 16:54:45 INFO rotate to next log name: mysql-bin.000015
轮流到下一个binlog
..........................................................................................................
省略

2018-08-08 16:55:03 DEBUG Issued INSERT on range: [13225026]..[13227026]; iteration: 5138; chunk-size: 2000
Copy: 10278000/10354932 99.3%; Applied: 2; Backlog: 0/1000; Time: 2m39s(total), 2m39s(copy); streamer: mysql-bin.000015:26929262; State: migrating; ETA: 1s
..........................................................................................................
省略

2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13291026]..[13293026]; iteration: 5171; chunk-size: 2000
Copy: 10344000/10354932 99.9%; Applied: 2; Backlog: 0/1000; Time: 2m40s(total), 2m40s(copy); streamer: mysql-bin.000015:28412792; State: migrating; ETA: 0s

2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13293026]..[13295026]; iteration: 5172; chunk-size: 2000
2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13295026]..[13297026]; iteration: 5173; chunk-size: 2000
2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13297026]..[13299026]; iteration: 5174; chunk-size: 2000
2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13299026]..[13301026]; iteration: 5175; chunk-size: 2000
2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13301026]..[13303026]; iteration: 5176; chunk-size: 2000
2018-08-08 16:55:04 DEBUG Issued INSERT on range: [13303026]..[13303956]; iteration: 5177; chunk-size: 2000

2018-08-08 16:55:04 DEBUG Iteration complete: no further range to iterate
迭代完成：没有进一步的迭代范围

2018-08-08 16:55:04 INFO Row copy complete
row-copy完成

2018-08-08 16:55:04 DEBUG Iteration complete: no further range to iterate
迭代完成：没有进一步的迭代范围

2018-08-08 16:55:04 DEBUG Getting nothing in the write queue. Sleeping...
在写队列中什么都没有，进入睡眠状态
Copy: 10354930/10354930 100.0%; Applied: 2; Backlog: 0/1000; Time: 2m40s(total), 2m40s(copy); streamer: mysql-bin.000015:28654886; State: migrating; ETA: due
Applied: 2;  表示在二进制日志中处理并应用于ghost表的条目数，这次为2
ETA: due

2018-08-08 16:55:04 DEBUG checking for cut-over postpone
检查到表切换延迟存在
# postpone-cut-over-flag-file: /tmp/gh-ost.postpone.flag [set]

2018-08-08 16:55:05 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:06 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:07 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:08 DEBUG Getting nothing in the write queue. Sleeping...
Copy: 10354930/10354930 100.0%; Applied: 2; Backlog: 0/1000; Time: 2m45s(total), 2m40s(copy); streamer: mysql-bin.000015:28689616; State: postponing cut-over; ETA: due
在写队列中什么都没有，进入睡眠状态

2018-08-08 16:55:09 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:10 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:11 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:12 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:13 DEBUG Getting nothing in the write queue. Sleeping...
Copy: 10354930/10354930 100.0%; Applied: 2; Backlog: 0/1000; Time: 2m50s(total), 2m40s(copy); streamer: mysql-bin.000015:28720698; State: postponing cut-over; ETA: due
..........................................................................................................

Copy: 10354930/10354930 100.0%; Applied: 2; Backlog: 0/1000; Time: 2m55s(total), 2m40s(copy); streamer: mysql-bin.000015:28751795; State: postponing cut-over; ETA: due
..........................................................................................................

Copy: 10354930/10354930 100.0%; Applied: 2; Backlog: 0/1000; Time: 3m30s(total), 2m40s(copy); streamer: mysql-bin.000015:28969425; State: postponing cut-over; ETA: due
2018-08-08 16:55:54 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:55:55 DEBUG Getting nothing in the write queue. Sleeping...

..........................................................................................................
2018-08-08 16:56:38 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:56:39 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:56:40 DEBUG ApplyDMLEventQueries() applied 1 events in one transaction
应用binlog中一个新事务到ghost表
..........................................................................................................

2018-08-08 16:56:51 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:56:52 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:56:53 DEBUG Getting nothing in the write queue. Sleeping...
Copy: 10354930/10354930 100.0%; Applied: 3; Backlog: 0/1000; Time: 4m30s(total), 2m40s(copy); streamer: mysql-bin.000015:29336466; State: postponing cut-over; ETA: due
..........................................................................................................

Copy: 10354930/10354930 100.0%; Applied: 3; Backlog: 0/1000; Time: 5m0s(total), 2m40s(copy); streamer: mysql-bin.000015:29518711; State: postponing cut-over; ETA: due
..........................................................................................................

在写完最后一个事务后，执行表切换操作
$ rm -f /tmp/gh-ost.postpone.flag   

Copy: 10354930/10354930 100.0%; Applied: 3; Backlog: 0/1000; Time: 5m30s(total), 2m40s(copy); streamer: mysql-bin.000015:29700975; State: postponing cut-over; ETA: due
..........................................................................................................

2018-08-08 16:58:22 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:23 DEBUG Getting nothing in the write queue. Sleeping...
Copy: 10354930/10354930 100.0%; Applied: 3; Backlog: 0/1000; Time: 6m0s(total), 2m40s(copy); streamer: mysql-bin.000015:29883187; State: postponing cut-over; ETA: due
可以看到binlog在row-copy完成后一直在增长：
1> 业务sql在做dml操作
2> row-copy(完成后就不算了)
3> 进度表更新操作
4> 人为写入操作

2018-08-08 16:58:24 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:25 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:26 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:27 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:28 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:29 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:30 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:31 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:32 DEBUG Getting nothing in the write queue. Sleeping...
2018-08-08 16:58:33 DEBUG Getting nothing in the write queue. Sleeping...

2018-08-08 16:58:34 DEBUG checking for cut-over postpone: complete
检测到延迟表切换标志不存在后

2018-08-08 16:58:34 DEBUG Getting nothing in the write queue. Sleeping...

2018-08-08 16:58:34 INFO Grabbing voluntary lock: gh-ost.1157.lock
抢占自愿锁gh-ost.1157.lock

2018-08-08 16:58:34 INFO Setting LOCK timeout as 6 seconds
设置锁超时6s

2018-08-08 16:58:34 INFO Looking for magic cut-over table
2018-08-08 16:58:34 INFO Creating magic cut-over table `db1`.`_t1_20180808165224_del`
2018-08-08 16:58:34 INFO Magic cut-over table created
寻找magic切换表
创建切换表`db1`.`_t1_20180808165224_del`，即原始表
原始表被创建
在表切换前，先创建重命名后的原表

2018-08-08 16:58:34 INFO Locking `db1`.`t1`, `db1`.`_t1_20180808165224_del`
2018-08-08 16:58:34 INFO Tables locked
2018-08-08 16:58:34 INFO Session locking original & magic tables is 1157
新建session先锁定重命名后的原表 & 此表空间id 1157

2018-08-08 16:58:34 INFO Writing changelog state: AllEventsUpToLockProcessed:1533718714984839844
将状态AllEventsUpToLockProcessed:1533718714984839844写入进度表

2018-08-08 16:58:34 INFO Intercepted changelog state AllEventsUpToLockProcessed
拦截进度表中AllEventsUpToLockProcessed状态

2018-08-08 16:58:34 INFO Handled changelog state AllEventsUpToLockProcessed
处理进度表中AllEventsUpToLockProcessed状态

2018-08-08 16:58:34 INFO Waiting for events up to lock
等待事件锁定

2018-08-08 16:58:35 DEBUG Getting nothing in the write queue. Sleeping...

2018-08-08 16:58:35 INFO Waiting for events up to lock: got AllEventsUpToLockProcessed:1533718714984839844
等待获取事件锁 AllEventsUpToLockProcessed:1533718714984839844

2018-08-08 16:58:35 INFO Done waiting for events up to lock; duration=844.702089ms
获取事件锁完成，花费/持续时间 duration=844.702089ms

# Migrating `db1`.`t1`; Ghost table is `db1`.`_t1_gho`
# Migrating dbhost:3309; inspecting dbhost:3309; executing on dbhost
# Migration started at Wed Aug 08 16:52:24 +0800 2018
# chunk-size: 2000; max-lag-millis: 1500ms; dml-batch-size: 30; max-load: Threads_running=100,threads_connected=100; critical-load: Threads_running=120,threads_connected=120; nice-ratio: 0.000000
# throttle-additional-flag-file: /tmp/gh-ost.throttle 
# postpone-cut-over-flag-file: /tmp/gh-ost.postpone.flag 
# panic-flag-file: /tmp/gh-ost.panic.flag
# Serving on unix socket: /tmp/gh-ost.db1.t1.sock
Copy: 10354930/10354930 100.0%; Applied: 3; Backlog: 0/1000; Time: 6m11s(total), 2m40s(copy); streamer: mysql-bin.000015:29953244; State: migrating; ETA: due

2018-08-08 16:58:35 INFO Setting RENAME timeout as 3 seconds
设置表重命名超时时间

2018-08-08 16:58:35 INFO Session renaming tables is 1162
重命名表的空间id 1162

2018-08-08 16:58:35 INFO Issuing and expecting this to block: rename /* gh-ost */ table `db1`.`t1` to `db1`.`_t1_20180808165224_del`, `db1`.`_t1_gho` to `db1`.`t1`
发布并期望阻止：rename table 原表 to _del, ghost表 to 原表

2018-08-08 16:58:35 INFO Found atomic RENAME to be blocking, as expected. Double checking the lock is still in place (though I don't strictly have to)
发现atomic rename是阻塞的，这是期望的结果。双重检查锁仍然存在(虽然没有严格要求)

2018-08-08 16:58:35 INFO Checking session lock: gh-ost.1157.lock
检查session lock gh-ost.1157.lock

2018-08-08 16:58:35 INFO Connection holding lock on original table still exists
原始表上的连接保持锁仍然存在

2018-08-08 16:58:35 INFO Will now proceed to drop magic table and unlock tables
现在将继续删除魔术表(即，提前创建好的原始表重命名后的表)并解锁表

2018-08-08 16:58:35 INFO Dropping magic cut-over table
删除提前创建好的原始表重命名后的表

2018-08-08 16:58:35 INFO Releasing lock from `db1`.`t1`, `db1`.`_t1_20180808165224_del`
释放锁`db1`.`t1`, `db1`.`_t1_20180808165224_del`

2018-08-08 16:58:35 INFO Tables unlocked
之前锁定的2张表被释放 `db1`.`t1`, `db1`.`_t1_20180808165224_del`

2018-08-08 16:58:35 INFO Tables renamed
表被重命名

2018-08-08 16:58:35 INFO Lock & rename duration: 947.690881ms. During this time, queries on `t1` were blocked
锁定 & 重命名持续时间947.690881ms。在此期间，对t1的查询被阻止

2018-08-08 16:58:35 INFO Looking for magic cut-over table
寻找magic切换表

2018/08/08 16:58:35 binlogsyncer.go:107: [info] syncer is closing... 
主从同步线程关闭中

2018/08/08 16:58:36 binlogstreamer.go:47: [error] close sync with err: sync is been closing...

2018/08/08 16:58:36 binlogsyncer.go:122: [info] syncer is closed 
主从同步线程已经关闭

2018-08-08 16:58:36 INFO Closed streamer connection. err=<nil>
关闭连接

2018-08-08 16:58:36 INFO Dropping table `db1`.`_t1_ghc`
删除进度表

2018-08-08 16:58:36 DEBUG done streaming events
2018-08-08 16:58:36 DEBUG Done streaming
完成流事件

2018-08-08 16:58:36 INFO Table dropped
删除进度表成功

2018-08-08 16:58:36 INFO Am not dropping old table because I want this operation to be as live as possible. If you insist I should do it, please add `--ok-to-drop-table` next time. But I prefer you do not. To drop the old table, issue:
2018-08-08 16:58:36 INFO -- drop table `db1`.`_t1_20180808165224_del`
原始表是否删除由参数--ok-to-drop-table决定，建议等待验证成功一段时间后再删除，如果磁盘空间不着急

2018-08-08 16:58:36 INFO Done migrating `db1`.`t1`
迁移t1表完成

2018-08-08 16:58:36 INFO Removing socket file: /tmp/gh-ost.db1.t1.sock
删除套接字文件

2018-08-08 16:58:36 INFO Tearing down inspector
拆除检查者线程

2018-08-08 16:58:36 INFO Tearing down applier
拆除应用binlog events线程

2018-08-08 16:58:36 DEBUG Tearing down...
2018-08-08 16:58:36 INFO Tearing down streamer
拆除流线程

2018-08-08 16:58:36 INFO Tearing down throttler
2018-08-08 16:58:36 DEBUG Tearing down...
拆除限制/节流线程

# Done

real    6m11.537s
user    0m32.255s
sys     0m3.682s


检查：
SQL> show tables;
+------------------------+
| Tables_in_db1          |
+------------------------+
| _t1_20180808165224_del |
| t1                     |
| t8                     |
+------------------------+
3 rows in set (0.00 sec)

检查新老表结构/行数：也可以在交换之前做(如果有数据在写，可以通过临时锁表对比)
SQL> show create table t1\G
*************************** 1. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(5) DEFAULT NULL,
  `c1` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `c2` varchar(150) NOT NULL DEFAULT 'xx',
  `c30` varchar(50) NOT NULL DEFAULT 'c30',
  `c3` varchar(10) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'xx',
  PRIMARY KEY (`id`),
  KEY `i_c3` (`c3`),
  KEY `i_c30` (`c30`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000003 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

SQL> show create table _t1_20180808165224_del\G
*************************** 1. row ***************************
       Table: _t1_20180808165224_del
Create Table: CREATE TABLE `_t1_20180808165224_del` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(5) DEFAULT NULL,
  `c1` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `c2` varchar(10) NOT NULL DEFAULT 'xx',
  `c30` varchar(50) NOT NULL DEFAULT 'c30',
  `c3` varchar(10) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'xx',
  PRIMARY KEY (`id`),
  KEY `i_c3` (`c3`),
  KEY `i_c30` (`c30`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000003 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

SQL> select count(*) from t1;
+----------+
| count(*) |
+----------+
| 10354933 |
+----------+
1 row in set (2.85 sec)

SQL> select count(*) from _t1_20180808165224_del;
+----------+
| count(*) |
+----------+
| 10354933 |
+----------+
1 row in set (1.89 sec)

