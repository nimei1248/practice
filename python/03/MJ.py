# coding:utf-8


## 打开文件,默认为r
f2 = open("www_access_20140823.log")

## 建立空字典用于存放以IP and status为key:其对应的访问次数为values的dict
d2 = {}


## 直接循环打开的文件类似于f2.readlines(),一行行读
for s in f2:
    ## 如果s为true,则以IP and status为key:其对应的访问次数为values,组成键值对存放在dict d2
    if s.strip():
        d2[s.split()[0],s.split()[8]] = d2.get((s.split()[0],s.split()[8]),0) + 1

## close open file
f2.close()


## 与上面写法差别,打开文件并保证最后f2.close(),而不需要手动close()
#with open("www_access_20140823.log",'r') as f2:
#    for s in f2:
#        if s.strip():
#            d2[s.split()[0],s.split()[8]] = d2.get((s.split()[0],s.split()[8]),0) + 1


## html
html_head = "<table border='1'>"

html_title = '''
                <tr>
	            <td>IP</td>
	            <td>Status</td>
	            <td>Count</td>
	        </tr>
            '''

html_body = '''
               <tr>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
               </tr>
           '''

html_end = '</table>'

#html = html_head + html_title
html = html_head + html_body % ('IP', 'Status', 'Count')


### 将dict conversion list
d2_conv_list = d2.items()

## 1.冒泡排序,从小到大
count = len(d2_conv_list)
for i in range(0, count):
    for j in range(i + 1, count):
        if d2_conv_list[i][1] > d2_conv_list[j][1]:
            d2_conv_list[i], d2_conv_list[j] = d2_conv_list[j], d2_conv_list[i]

## 取最后10个并倒序排列
d2_conv_list = d2_conv_list[-10:][::-1]


## 2.把dict convert list,通过sorted and lambda函数对d2的values进行排序,反转,取前10
#d2_conv_list = sorted(d2.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)[0:10]


## 循环打印list,并进行html拼接
for i in d2_conv_list:
     html = html + html_body % (i[0][0],i[0][1],i[1])

html = html + html_end


## write html to MJ.html
with open('MJ.html','w') as f3: f3.write(html)
