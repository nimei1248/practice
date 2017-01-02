#!/usr/local/python2711/bin/python
# *-* coding:utf-8 *-*


import re
import os
import sys
import time
import datetime
import subprocess
from time import clock as now
import smtplib
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
import socket
import fcntl
import struct


### global var
before = datetime.datetime.now() - datetime.timedelta(days=1)
beforedate = before.strftime("%Y-%m-%d")
backupdir = '/opt/domaincount/' + beforedate
#backupdir = '/opt/domaincount/' + (datetime.datetime.now() - datetime.timedelta(days=1)).strftime("%Y-%m-%d")
tmpfile = backupdir + '/' + 'nimei2.txt'


## 获取操作文件的名称
def getfile():
     #before = datetime.datetime.now() - datetime.timedelta(days=1)
     #beforedate = before.strftime("%Y-%m-%d")
     #backupdir = '/opt/domaincount/' + beforedate
     #tmpfile = backupdir + '/' + 'nimei2.txt'


     #subprocess.Popen("mkdir -p " + backupdir, shell=True)
     if not os.path.exists(backupdir):
         os.makedirs(backupdir)

     ## 清空文件/创建空文件
     subprocess.Popen("truncate -s 0 " + tmpfile, shell=True)

     #LOG_DIR = '/data/' + 'A02' + '/' + 'web' + '/access_log'
     log_name_cmd = "cd " + LOG_DIR + ' && ' + 'ls -lthr --time-style=long-iso | awk ' + "'" + '/' + beforedate + '/' + "'" + " | awk '{print $NF}'"
     f2 = subprocess.Popen(log_name_cmd, stdout=subprocess.PIPE, shell=True)
     f2.wait()

     ## 同一天的文件可能有多个
     ## cat file1 file2 file3 > tmp_file

     ## 取出同天多个文件名称:
     ## 方法1: f2.stdout.read()生成的是字符串,直接对字符串进行处理(去除首尾空格,空行;再按照'\n'切割后将str conver list)
     log_name_multiple = f2.stdout.read().strip().split('\n')

     ## 方法2: f2.communicate()生成的是元组,将元组中我们需要的字符串信息提出后
               ##再对字符串进行处理(去除首尾空格,空行;再按照'\n'切割后将str conver list)
     #log_name_multiple = f2.communicate()[0].strip().split('\n')

     ## 将文件名和path拼接
     for f in log_name_multiple:
         #print f
         log_name = LOG_DIR + '/' + f

         ## 判断文件是否存在,存在后是否大于0
         e = os.path.exists(log_name)
         s = os.path.getsize(log_name) > 0

         if e and s:
             ## 处理源文件的备份文件
             #print "cat " + log_name + ' >> ' + tmpfile
             bakfile = "cat " + log_name + ' >> ' + tmpfile
             f3 = subprocess.Popen(bakfile, shell=True)
             f3.wait()

     ## 判断文件是否存在,存在后是否大于0
     e2 = os.path.exists(tmpfile)
     s3 = os.path.getsize(tmpfile) > 0

     if e2 and s3:
         return tmpfile
     else:
         return 0

#getfile()

## 获取本机IP
def getip(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])


def treatfile(log_path):

    ## 统计当多个字段/指标同时成立时存放的dict, pc and mobile分别存放, mobile = m
    statistics = {}
    statistics_m = {}

    ## 统计单个字段, 如,域名字段存放的dict, pc and mobile分别存放, domain = d, mobile = m
    statistics_d = {}
    statistics_d_m = {}

    ## 统计两个字段,Domain and Uri and time, uri = u
    statistics_d_u = {}
    statistics_d_u_m = {}


    with open(log_path,'r') as f:
        for line in f:
            ## s.strip()去除首尾字符,默认是空格;语法: str.strip([chars]) chars:移除字符串头尾指定的字符
            ## 测试发现该函数的作用是去除字符串两端多余的whitespace,
            ## whitespace应该是空格,Tab和换行的统称,而不仅仅是空格
            ## 如果是空行,则为Fasle不成立

                #if domain not in statistics:
                #    statistics[domain] = 1
                #else:
                #    statistics[domain] += 1

            if line.strip():

                ## product
                try:
                    Product = line.split('の')[0]
                except IndexError,e:
                    continue

                ## type
                try:
                    Type = line.split('の')[1]
                except IndexError,e:
                    continue

                ## client ip
                try:
                    Cip = line.split('の')[2].split(',')[0]
                except IndexError,e:
                    continue

                ## LB ip
                try:
                    LBip = line.split('の')[3]
                except IndexError,e:
                    continue

                ## client access domain
                try:
                    Domain = line.split('の')[4]
                except IndexError,e:
                    #print "error: domain %s" % e
                    continue

                ## client access uri
                try:
                    Uri = line.split('の')[5]
                except IndexError,e:
                    continue
                  
                ## client access time
                try:
                    #Time = line.split('の')[6]
                    Time = line.split('の')[23].split('T')[0]
                except IndexError,e:
                    continue
                
                ## http method 
                try:
                    Method = line.split('の')[7]
                except IndexError,e:
                    continue

                ## http status 
                try:
                    Status = line.split('の')[8]
                except IndexError,e:
                    continue

                ## http referer 
                try:
                    Referer = line.split('の')[10]
                except IndexError,e:
                    continue

                ## country 
                try:
                    Country = line.split('の')[35]
                except IndexError,e:
                    continue

                ## capital 
                try:
                    Capital = line.split('の')[37]
                except IndexError,e:
                    continue

                ## state 
                try:
                    State = line.split('の')[38]
                except IndexError,e:
                    continue


                ## 去除不需要的统计
                ## 1.去除域名为'-'
                ## 2.LB设备访问探测/手工访问的URI, /time.php、/version.txt
                ## 3.公司内部人访问的IP(内网、公网),这点暂时没有过滤
                if Domain == '-' or Uri == '/version.txt' or Uri == '/time.php':
                    continue

                ## 单独统计手机域名m.开始域名
                elif Domain.split('.')[0] == 'm':
                    ## 统计手机版多个指标
                    tup_m = (Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Referer,Uri)
                    statistics_m[tup_m] = statistics_m.get(tup_m,0) + 1

                    ## 定义一个只有1个元素的tuple,t = (1),定义的不是tuple，是1这个数！这是因为括号()既可以表示tuple,
                    ## 又可以表示数学公式中的小括号,这就产生了歧义;
                    ## 因此,Python规定,这种情况下,按小括号进行计算,计算结果自然是1
                    ## 所以,只有1个元素的tuple定义时必须加一个逗号,来消除歧义

                    ## 统计手机版单个指标Domain
                    tup_d_m = (Domain,Product,Type,Time)
                    statistics_d_m[tup_d_m] = statistics_d_m.get(tup_d_m,0) + 1

                    ## 统计手机版指标Doamin and Uri
                    tup_d_u_m = (Domain,Product,Type,Time,Uri)
                    statistics_d_u_m[tup_d_u_m] = statistics_d_u_m.get(tup_d_u_m,0) + 1


                ## 统计除手机域名m.外所有域名
                else:
                    #tup = (domain,product,type,cip,lbip,status,time2,uri,method,referer,country,capital,state)
                    ## 统计除手机版外,目前主要是PC多个指标
                    tup = (Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Referer,Uri)
                    statistics[tup] = statistics.get(tup,0) + 1

                    ## 统计除手机版外,目前主要是PC单个指标Domain
                    tup_d = (Domain,Product,Type,Time)
                    statistics_d[tup_d] = statistics_d.get(tup_d,0) + 1

                    ## 统计除手机版外,目前主要是PC 指标 Domain and Uri
                    tup_d_u = (Domain,Product,Type,Time,Uri)
                    statistics_d_u[tup_d_u] = statistics_d_u.get(tup_d_u,0) + 1


        ### 删除字典中key值是-的元素
        #if '-' in statistics.keys():
        #    del statistics['-']


        ## dict convert list and sorted
        ## mutil index
        dcl = sorted(statistics.items(), key=lambda x:x[1], reverse=True)[0:100]
        dcl_m = sorted(statistics_m.items(), key=lambda x:x[1], reverse=True)[0:50]

        ## Count,Domain,Product,Type,Time 
        dcl_d = sorted(statistics_d.items(), key=lambda x:x[1], reverse=True)[0:30]
        dcl_d_m = sorted(statistics_d_m.items(), key=lambda x:x[1], reverse=True)[0:30]

        ## Count,Domain,Product,Type,Time,Uri 
        dcl_d_u = sorted(statistics_d_u.items(), key=lambda x:x[1], reverse=True)[0:50]
        dcl_d_u_m = sorted(statistics_d_u_m.items(), key=lambda x:x[1], reverse=True)[0:50]


	## html
        html_title = '<html><head><meta charset="UTF-8"><title>nginx日志分析</title></head><body>'
	html_head = html_title + '<table cellspacing="0" cellpadding="2" border="3" bgcolor="LightGreen">'
	html_end = '</table></body></html>'
        
        ## multi index
	#html_body = '<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>'
        html_body = '''
               <tr>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
               </tr>
           '''
	html = html_head + html_body % ('Count','Domain','Product','Type','Cip','LBip','Status','Time','Method','Country','Capital','State','Referer','Uri')
	html_m = html_head + html_body % ('Count','Domain','Product','Type','Cip','LBip','Status','Time','Method','Country','Capital','State','Referer','Uri')

        ## Count,Domain,Product,Type,Time
	#html_body_d = '<tr><td>%s</td><td>%s</td></tr>'
        html_body_d = '''
               <tr>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
               </tr>
            '''
        html_d = html_head + html_body_d % ('Count','Domain','Product','Type','Time')
        html_d_m = html_head + html_body_d % ('Count','Domain','Product','Type','Time')

        ## Count,Domain,Product,Type,Time,Uri
	#html_body_d_u = '<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>'
        html_body_d_u = '''
               <tr>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
               </tr>
            '''
        html_d_u = html_head + html_body_d_u % ('Count','Domain','Product','Type','Time','Uri')
        html_d_u_m = html_head + html_body_d_u % ('Count','Domain','Product','Type','Time','Uri')


        #for d in dcl,dcl_m:
        #    for (Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Uri),Count in d:
        #        if d == 'dcl_m':
        #            html_m = html_m + html_body % (Count,Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Uri)
        #        else:
        #            html = html + html_body % (Count,Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Uri)
                    

        ## statistics, multi
        for (Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Referer,Uri),Count in dcl_m:
               html_m = html_m + html_body % (Count,Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Referer,Uri)
        html_m = html_m + html_end 


        for (Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Referer,Uri),Count in dcl:
               html = html + html_body % (Count,Domain,Product,Type,Cip,LBip,Status,Time,Method,Country,Capital,State,Referer,Uri)
        html = html + html_end 
        

        ## statistics Count,Domain,Product,Type,Time 
        for (Domain,Product,Type,Time),Count in dcl_d_m:
                html_d_m = html_d_m + html_body_d % (Count,Domain,Product,Type,Time)
        html_d_m = html_d_m + html_end 


        for (Domain,Product,Type,Time),Count in dcl_d:
                html_d = html_d + html_body_d % (Count,Domain,Product,Type,Time)
        html_d = html_d + html_end 


        ## statistics Count,Domain,Product,Type,Time,Uri 
        for (Domain,Product,Type,Time,Uri),Count in dcl_d_u_m:
                html_d_u_m = html_d_u_m + html_body_d_u % (Count,Domain,Product,Type,Time,Uri)
        html_d_u_m = html_d_u_m + html_end 


        for (Domain,Product,Type,Time,Uri),Count in dcl_d_u:
                html_d_u = html_d_u + html_body_d_u % (Count,Domain,Product,Type,Time,Uri)
        html_d_u = html_d_u + html_end 


        ## write html to stat.html
        #for h in html,html_m:
        #    if h == 'html_m':
        #        with open('stat_m.html','w') as f_m: f_m.write(html_m)
        #    else:
        #        with open('stat.html','w') as f: f.write(html)
        
        ## +  open a disk file for updating(reading and writing),打开磁盘文件进行更新(读写)
        ## a+ 可读写模式,写只能写在文件末尾
        ## w+ 可读写模式与a+的区别是要清空文件的内容
        ## r+ 可读写与a+的区别是可以写到文件的任何位置

        html_path = backupdir + '/'

        ## write multi index file
        with open(html_path + 'stat.html','a+') as f: f.write(html)
        with open(html_path + 'stat_m.html','a+') as f_m: f_m.write(html_m)


        ## write single index Domain file
        with open(html_path + 'stat_d.html','a+') as f_d: f_d.write(html_d)
        with open(html_path + 'stat_d_m.html','a+') as f_d_m: f_d_m.write(html_d_m)


        ## write two index Domain and Uri file
        with open(html_path + 'stat_d_u.html','a+') as f_d_u: f_d_u.write(html_d_u)
        with open(html_path + 'stat_d_u_m.html','a+') as f_d_u_m: f_d_u_m.write(html_d_u_m)


    ### re.search()
    #for k,v in old_result:
    #    if re.search(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', k) != None:
    #        continue
    #    elif re.search(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:(\d+)$', k) != None:
    #        continue

    #    new_statistics[k] = v


    ### re.match()
    ##for k,v in old_result:
    ##    if re.match(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', k) != None:
    ##        continue
    ##    elif re.match(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:(\d+)$', k) != None:
    ##        continue

    ##    new_statistics[k] = v


    ### 模糊匹配,同时匹配IP和IP:PORT
    ##for k,v in old_result:
    ##    if re.match(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}', k) != None:
    ##        continue

    ##    new_statistics[k] = v

    #new_result = sorted(new_statistics.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)


    #for k,v in new_result:
    #    # python 2.6.6
    #    #print CP + ' ' + '{0} {1}'.format(str(v),k)
    #    #print ("%-5s" % CP) + ("%-10d" % v) + ("%-10s" % k)
    #    result2 = ("%-5s" % CP) + ',' + ("%-10d" % v) + ',' + ("%-10s" % k) + '\n'
    #    #result2 = CP + ',' + '{1},{0}'.format(str(v),k) + '\n'

    #    # python 2.7.11
    #    #print '{:10s} {:<10s}'.format(str(v),k)
    #    #result2 = '{:10s} {:<10s}'.format(str(v),k) + '\n'

    #    with open(result3, 'a+') as f2:
    #        f2.write(result2)
    #    f2.close()

    #f.close()


#treatfile(getfile())

## sendmail
def SendMail():
    HOST = "10.252.252.112"
    PORT = "25"
    SUBJECT = u"产品域名统计 from %s" % getip('eth0')
    TO = ["aa@abc.com"]
    FROM = "b2@abc.com"
    CC = ["abc@abc.com"]


    tolist = ','.join(TO)
    cclist = ','.join(CC)


    #msgtext2 = MIMEText(beforedate + '' + '排名前30的域名:' + '\n' + open(stats_pc_m,"r").read())
    msgtext2 = MIMEText(beforedate + ' ' + '详情见附件' + '\n')

    msg = MIMEMultipart()
    msg.attach(msgtext2)


    attach = MIMEText(open(stats_result,"r").read(), "base64", "utf-8")
    attach["Content-Type"] = "application/octet-stream"
    attach["Content-Disposition"] = "attachment; filename=\"statistics_log.zip\"".decode("utf-8").encode("utf-8")
    msg.attach(attach)


    msg['Subject'] = SUBJECT
    msg['From'] = FROM
    msg['To'] = tolist
    msg['Cc'] = cclist


    try:
        server = smtplib.SMTP()
        server.connect(HOST, PORT)
        #server.starttls()
        #server.login("test@gmail.com","123456")
        server.sendmail(FROM, TO + CC, msg.as_string())
        server.quit()
        #print "send mail success!"
    except Exception, e:
        print "Error: " + str(e)


## exec function
if __name__ == "__main__":
    CPS = ['A02', 'A03', 'A04', 'A05', 'A07', 'B01', 'B05', 'B06', 'C02', 'C07', 'E02', 'E03', 'E04']
    ROLE = 'web'


    ## 写入文件之前删除已经存在的文件
    os.system('rm -f backupdir/stat*')

 
    ## 循环执行每个产品
    for CP in CPS:
        print '-------------%s-----------' % CP
        LOG_DIR = '/data/' + CP + '/' + ROLE + '/access_log'
        if getfile() is 0:
            continue
        else:
            treatfile(getfile())

    
    ## 发送文本 stats domain pc + m
    stats_pc = backupdir + '/' + 'stat.html'
    stats_m = backupdir + '/' + 'stat_m.html'
    os.system('cat ' + stats_m + ' >> ' + stats_pc)
    stats_pc_m = stats_pc

    ### zip压缩日志作为附件发送
    os.system('zip -qj ' + backupdir + '/statistics_log.zip ' + backupdir + '/stat*.html')
    stats_result = backupdir + '/' + 'statistics_log.zip'

    ## send mail
    SendMail()

    ## 删除临时文件
    os.system('rm -f ' + tmpfile)
