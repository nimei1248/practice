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


## global var
before = datetime.datetime.now() - datetime.timedelta(days=1)
beforedate = before.strftime("%Y-%m-%d")
backupdir = '/opt/domaincount/' + beforedate
#backupdir = '/opt/domaincount/' + (datetime.datetime.now() - datetime.timedelta(days=1)).strftime("%Y-%m-%d")
tmpfile = backupdir + '/' + 'nimei2.txt'


def getfile():
     #subprocess.Popen("mkdir -p " + backupdir, shell=True)
     if not os.path.exists(backupdir):
         os.makedirs(backupdir)

     ## 清空 or 创建文件
     subprocess.Popen("truncate -s 0 " + tmpfile, shell=True)

     LOG_DIR = '/data/' + 'A02' + '/' + 'web' + '/access_log'
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
         print f
         log_name = LOG_DIR + '/' + f

         ## 判断文件是否存在,存在后是否大于0
         e = os.path.exists(log_name)
         s = os.path.getsize(log_name) > 0

         if e and s:
             ## 处理源文件的备份文件
             print "cat " + log_name + ' >> ' + tmpfile
             bakfile = "cat " + log_name + ' >> ' + tmpfile
             f3 = subprocess.Popen(bakfile, shell=True)
             f3.wait()
         else:
             #print log_name + ' file is not exists'
             return 0


## 获取本机IP
def getip(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])


def treatfile(log_path = tmpfile):
    statistics = {}

    new_statistics = {}

    with open(log_path,'r') as f:
        for line in f:
            ## s.strip()去除首尾字符,默认是空格;语法: str.strip([chars]) chars:移除字符串头尾指定的字符
            ## 测试发现该函数的作用是去除字符串两端多余的whitespace,whitespace应该是空格,Tab和换行的统称,而不仅仅是空格
            ## 如果是空行,则为Fasle不成立

                #if domain not in statistics:
                #    statistics[domain] = 1
                #else:
                #    statistics[domain] += 1

            if line.strip():

                ## product
                try:
                    product = line.split('の')[0]
                except IndexError,e:
                    continue

                ## type
                try:
                    type = line.split('の')[1]
                except IndexError,e:
                    continue

                ## client ip
                try:
                    cip = line.split('の')[2].split(',')[0]
                except IndexError,e:
                    continue

                ## LB ip
                try:
                    lbip = line.split('の')[3]
                except IndexError,e:
                    continue

                ## client access domain
                try:
                    domain = line.split('の')[4]
                except IndexError,e:
                    #print "error: domain %s" % e
                    continue

                ## client access uri
                try:
                    uri = line.split('の')[5]
                except IndexError,e:
                    continue
                  
                ## client access time
                try:
                    #time2 = line.split('の')[6]
                    time2 = line.split('の')[23].split('T')[0]
                except IndexError,e:
                    continue
                
                ## http method 
                try:
                    method = line.split('の')[7]
                except IndexError,e:
                    continue

                ## http status 
                try:
                    status = line.split('の')[8]
                except IndexError,e:
                    continue

                ## http referer 
                try:
                    referer = line.split('の')[10]
                except IndexError,e:
                    continue

                ## country 
                try:
                    country = line.split('の')[35]
                except IndexError,e:
                    continue

                ## capital 
                try:
                    capital = line.split('の')[37]
                except IndexError,e:
                    continue

                ## state 
                try:
                    state = line.split('の')[38]
                except IndexError,e:
                    continue


                tup = (domain,product,type,cip,lbip,status,time2,uri,method,referer,country,capital,state)
                statistics[tup] = statistics.get(tup,0) + 1

		## html
		html_head = "<table border='1'>"

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

		html_end = '</table>'


		html = html_head + html_body % ('domain','product','type','cip','lbip','status','time2','uri','method','referer','country','capital','state','count')

        ## 删除字典中key值是-的元素
        if '-' in statistics.keys():
            del statistics['-']

        list2 = sorted(statistics.items(), key=lambda x:x[1], reverse=True)[0:72]

        for i in list2:
            html = html + html_body % (i[0][0],i[0][1],i[0][2],i[0][3],i[0][4],i[0][5],i[0][6],i[0][7],i[0][8],i[0][9],i[0][10],i[0][11],i[0][12],i[0][13],i[1])

        html = html + html_end 
        
        ## write html to stat.html
        with open('stat.html','w') as f: f.write(html)
        


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


treatfile()

### sendmail
#def SendMail():
#    HOST = "10.252.252.112"
#    PORT = "25"
#    SUBJECT = u"产品域名统计 from %s" % getip('eth0')
#    TO = ["shaw@iv66.net"]
#    FROM = "b2@iv66.net"
#    CC = ["oliver@iv66.net","axe@iv66.net","jerry@iv66.net"]
#
#
#    tolist = ','.join(TO)
#    cclist = ','.join(CC)
#
#
#    msgtext2 = MIMEText(beforedate + '' + '排名前30的域名:' + '\n' + open(result3,"rb").read().replace(',',' '))
#    msgtext1 = MIMEText("""
#        <table width="800" border="0" cellspacing="0" cellpadding="4">
#            <tr>
#                <td bgcolor="#CECFAD" height="20" style="font-size:14px">排名前30的域名: <a href="www.w66.com">点我点我</a></td>
#            </tr>
#
#        </table>""","html","utf-8")
#
#
#    msg = MIMEMultipart()
#    #msg.attach(msgtext1)
#    msg.attach(msgtext2)
#
#
#    #print result3
#    attach = MIMEText(open(result3,"rb").read(), "base64", "utf-8")
#    attach["Content-Type"] = "application/octet-stream"
#    attach["Content-Disposition"] = "attachment; filename=\"web_domain_count.csv\"".decode("utf-8").encode("utf-8")
#    msg.attach(attach)
#
#
#    msg['Subject'] = SUBJECT
#    msg['From'] = FROM
#    msg['To'] = tolist
#    msg['Cc'] = cclist
#
#
#    try:
#        server = smtplib.SMTP()
#        server.connect(HOST, PORT)
#        #server.starttls()
#        #server.login("test@gmail.com","123456")
#        server.sendmail(FROM, TO + CC, msg.as_string())
#        server.quit()
#        #print "send mail success!"
#    except Exception, e:
#        print "Error: " + str(e)
#
#
#
#if __name__ == "__main__":
#    CPS = ['A01', 'A02', 'A03', 'A04', 'A05', 'A07', 'B01', 'B05', 'B06', 'C02', 'C07', 'E02', 'E03', 'E04']
#    ROLE = 'web'
#
#    result3 = backupdir + '/' + 'web_domain_count.csv'
#    os.system('rm -f ' + result3)
#
#    for CP in CPS:
#        #print '-------------%s-----------' % CP
#        LOG_DIR = '/data/' + CP + '/' + ROLE + '/access_log'
#        if getfile() is 0:
#            #print
#            continue
#        treatfile()
#        #print
#
#
#    SendMail()
#    os.system('rm -f ' + tmpfile)
#    time2 = now()
#    #print
#    #print 'run time is ' + str(time2 - time1) + 's'
