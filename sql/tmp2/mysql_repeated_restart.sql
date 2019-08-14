Cent0S7 rpm安装的mysql，如果有异常无法正常启动，会通过守护进程反复重启mysqld

mysql error.log:

INSERT INTO t1 
(ID, pkey, issuenum, PROJECT, REPORTER, ASSIGNEE, CREATOR, issuetype, SUMMARY, DESCRIPTION, ENVIRONMENT, PRIORITY, RESOLUTION, issuestatus, CREATED, UPDATED, DUEDATE, RESOLUTIONDATE, VOTES, WATCHES, TIMEORIGINALESTIMATE, TIMEESTIMATE, TIMESPENT, WORKFLOW_ID, SECURITY, FIXFOR, COMPONENT) 
values 
(15697, null, 28160, 10000, 'xxx', null, 'xxx', '10001', 'S1', 'xxx', null, '2', null, '10100', '2019-08-14 10:52:57.071', '2019-08-14 10:52:57.071', null, null, 0, 0, null, null, null, 56425, null, null, null);
ERROR 2013 (HY000): Lost connection to MySQL server during query


2019-08-14 11:12:18 0x7f19c0184700  InnoDB: Assertion failure in thread 139748573726464 in file btr0cur.cc line 325
                                    InnoDB：文件btr0cur.cc第325行中的线程139748573726464中的断言失败

InnoDB: Failing assertion: btr_page_get_next( latch_leaves.blocks[0]->frame, mtr) == page_get_page_no(page)

storage/innobase/btr/btr0cur.cc:3788:  ut_a(btr_page_get_next(prev_block->frame, mtr) == page_get_page_no(page));
storage/innobase/btr/btr0btr.cc:2715:    ut_a(btr_page_get_next(prev_page, mtr) == page_get_page_no(page));
storage/innobase/ibuf/ibuf0ibuf.cc:2737:  ut_a(btr_page_get_next(prev_page, mtr) == page_get_page_no(page));


InnoDB: We intentionally generate a memory trap.
InnoDB: Submit a detailed bug report to http://bugs.mysql.com.
InnoDB: If you get repeated assertion failures or crashes, even
InnoDB: immediately after the mysqld startup, there may be
InnoDB: corruption in the InnoDB tablespace. Please refer to
InnoDB: http://dev.mysql.com/doc/refman/5.7/en/forcing-innodb-recovery.html
InnoDB: about forcing recovery.
如果你反复断言失败或崩溃，甚至在mysqld启动之后，InnoDB表空间可能会出现损坏

03:12:18 UTC - mysqld got signal 6 ;
This could be because you hit a bug. It is also possible that this binary
or one of the libraries it was linked against is corrupt, improperly built,
or misconfigured. This error can also be caused by malfunctioning hardware.
Attempting to collect some information that could help diagnose the problem.
As this is a crash and something is definitely wrong, the information
collection process might fail.
这可能是因为你遇到了一个bug。 这个二进制文件也有可能或者它所链接的其中一个图书馆是腐败的，不正确的，或配置错误。 此错误也可能由硬件故障引起。
试图收集一些有助于诊断问题的信息。因为这是一次崩溃而且肯定是错误的，这些信息收集过程可能会失败

key_buffer_size=67108864
read_buffer_size=131072
max_used_connections=2
max_threads=151
thread_count=1
connection_count=1
It is possible that mysqld could use up to 
key_buffer_size + (read_buffer_size + sort_buffer_size)*max_threads = 125540 K  bytes of memory
Hope that's ok; if not, decrease some variables in the equation.

Thread pointer: 0x7f199800abc0
Attempting backtrace. You can use the following information to find out
where mysqld died. If you see no messages after this, something went
terribly wrong...
stack_bottom = 7f19c0183e30 thread_stack 0x40000
/usr/sbin/mysqld(my_print_stacktrace+0x3b)[0xf0768b]
/usr/sbin/mysqld(handle_fatal_signal+0x461)[0x7b9311]
/lib64/libpthread.so.0(+0xf5d0)[0x7f1b2daf55d0]
/lib64/libc.so.6(gsignal+0x37)[0x7f1b2c4df207]
/lib64/libc.so.6(abort+0x148)[0x7f1b2c4e08f8]
/usr/sbin/mysqld[0x789636]
/usr/sbin/mysqld(_Z20btr_cur_latch_leavesP11buf_block_tRK9page_id_tRK11page_size_tmP9btr_cur_tP5mtr_t+0x8e5)[0x10f7975]
/usr/sbin/mysqld(_Z27btr_cur_search_to_nth_levelP12dict_index_tmPK8dtuple_t15page_cur_mode_tmP9btr_cur_tmPKcmP5mtr_t+0x1a7c)[0x10fec5c]
/usr/sbin/mysqld(_Z29row_ins_clust_index_entry_lowmmP12dict_index_tmP8dtuple_tmP9que_thr_tb+0x24f)[0x101957f]
/usr/sbin/mysqld(_Z25row_ins_clust_index_entryP12dict_index_tP8dtuple_tP9que_thr_tmb+0x162)[0x101aa82]
/usr/sbin/mysqld(_Z12row_ins_stepP9que_thr_t+0x376)[0x101b3d6]
/usr/sbin/mysqld[0x102d48e]
/usr/sbin/mysqld(_ZN11ha_innobase9write_rowEPh+0x1d6)[0xf4c996]
/usr/sbin/mysqld(_ZN7handler12ha_write_rowEPh+0x122)[0x80dbc2]
/usr/sbin/mysqld(_Z12write_recordP3THDP5TABLEP9COPY_INFOS4_+0xb9)[0xe4d7b9]
/usr/sbin/mysqld(_ZN14Sql_cmd_insert12mysql_insertEP3THDP10TABLE_LIST+0x8a5)[0xe4ea65]
/usr/sbin/mysqld(_ZN14Sql_cmd_insert7executeEP3THD+0xea)[0xe4f2ba]
/usr/sbin/mysqld(_Z21mysql_execute_commandP3THDb+0x5d0)[0xccd6e0]
/usr/sbin/mysqld(_Z11mysql_parseP3THDP12Parser_state+0x3ad)[0xcd39bd]
/usr/sbin/mysqld(_Z16dispatch_commandP3THDPK8COM_DATA19enum_server_command+0xa7d)[0xcd451d]
/usr/sbin/mysqld(_Z10do_commandP3THD+0x19f)[0xcd5f1f]
/usr/sbin/mysqld(handle_connection+0x290)[0xd97dc0]
/usr/sbin/mysqld(pfs_spawn_thread+0x1b4)[0x127fae4]
/lib64/libpthread.so.0(+0x7dd5)[0x7f1b2daeddd5]
/lib64/libc.so.6(clone+0x6d)[0x7f1b2c5a6ead]

Trying to get some variables.
Some pointers may be invalid and cause the dump to abort.
试图得到一些变量
某些指针可能无效并导致转储中止

Query (7f1998016140): INSERT INTO t1  (ID, pkey, issuenum, PROJECT, REPORTER, ASSIGNEE, CREATOR, issuetype, SUMMARY, DESCRIPTION, ENVIRONMENT, PRIORITY, RESOLUTION, issuestatus, CREATED, UPDATED, DUEDATE, RESOLUTIONDATE, VOTES, WATCHES, TIMEORIGINALESTIMATE, TIMEESTIMATE, TIMESPENT, WORKFLOW_ID, SECURITY, FIXFOR, COMPONENT)  values (15697, null, 28160, 10000, 'xxx', null, 'xxx', '10001', 'S1', 'xxx', null, '2', null, '10100', '2019-08-14 10:52:57.071', '2019-08-14 10:52:57.071', null, null, 0, 0, null, null, null, 56425, null, null, null)
Connection ID (thread ID): 18
Status: NOT_KILLED





mysql> show create table t1\G
*************************** 1. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `ID` decimal(18,0) NOT NULL,
  `pkey` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `issuenum` decimal(18,0) DEFAULT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `REPORTER` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ASSIGNEE` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `issuetype` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `SUMMARY` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION` longtext COLLATE utf8_bin,
  `ENVIRONMENT` longtext COLLATE utf8_bin,
  `PRIORITY` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `RESOLUTION` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `issuestatus` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `DUEDATE` datetime DEFAULT NULL,
  `RESOLUTIONDATE` datetime DEFAULT NULL,
  `VOTES` decimal(18,0) DEFAULT NULL,
  `WATCHES` decimal(18,0) DEFAULT NULL,
  `TIMEORIGINALESTIMATE` decimal(18,0) DEFAULT NULL,
  `TIMEESTIMATE` decimal(18,0) DEFAULT NULL,
  `TIMESPENT` decimal(18,0) DEFAULT NULL,
  `WORKFLOW_ID` decimal(18,0) DEFAULT NULL,
  `SECURITY` decimal(18,0) DEFAULT NULL,
  `FIXFOR` decimal(18,0) DEFAULT NULL,
  `COMPONENT` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `issue_proj_num` (`issuenum`,`PROJECT`),
  KEY `issue_proj_status` (`PROJECT`,`issuestatus`),
  KEY `issue_created` (`CREATED`),
  KEY `issue_updated` (`UPDATED`),
  KEY `issue_duedate` (`DUEDATE`),
  KEY `issue_resolutiondate` (`RESOLUTIONDATE`),
  KEY `issue_assignee` (`ASSIGNEE`),
  KEY `issue_reporter` (`REPORTER`),
  KEY `issue_workflow` (`WORKFLOW_ID`),
  KEY `issue_votes` (`VOTES`),
  KEY `issue_watches` (`WATCHES`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin
1 row in set (0.00 sec)