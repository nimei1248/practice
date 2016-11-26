#coding=utf-8


## 获取用户的输入
#x = raw_input('Please input your name: ')
#print x


## 打印字符串
#print 'hello world'
#print "I'm happy"
#print 'I"m happy'
#print '''
#asdasd ''""'sad'asd''asd''
#
#'''
#
#print '=' * 30
#name = 'fuck'
#type = 'ops'
#
#print 'hello I am ' + name + '.and I love ' + type


## 变量
## 2种引用变量发生,第2种更好
## %d显示整数,如果age是小数,也会显示整数;
## %s更通用,是什么就显示什么
#name = 'nimei'
#age = 2
#age2 = 2.1
#print 'hello ' + name + '.and I am ' + str(age) + ' years old'
#print 'hello %s.and I am %s years old' %(name,age)
#print 'hello %s.and I am %d years old' %(name,age2)
#print 'hello %s.and I am %s years old' %(name,age2)



## int(str)把字符串转成数字类型
#print '2' + '4'
#print 2 + '4'
#print 2 + int('4')



## 求2个数平均值
#x = raw_input('Please input number 1: ')
#y = raw_input('Please input number 2: ')
#z = int(x) + int(y)
#print z / 2.0   ## 考虑浮点数情况,这里有一个参数的是浮点类型

#x = raw_input('Please input number 1: ')
#y = raw_input('Please input number 2: ')
#print x ## 打印的是字符串
#print y ## 打印的是字符串
#print (int(x) + int(y)) / 2 ## 只能得到整数
#print (int(x) + int(y)) / 2.0 ## 浮点数
#print float(int(x) + int(y)) / 2 ## 浮点数



## 流程控制
## 布尔值 True False
#if 条件为True:
#    执行这里代码
#   ...
#else 条件为False
#    执行这里代码
#   ...
#
#单个=号是赋值,双==号是判断

#name = raw_input('Please input your name: ')
#if name == 'nimei':
#    print 'Hello nimei'
#    print 'hahaha'
#else:
#    print 'you are not nimei'
#
#print 'not if in'


# A and B
## A 和 B都为True,则为True,其它均为False
#name = raw_input('Please input your name: ')
#age = raw_input('Please input your age: ')
#if name == 'nimei' and age == '2':
#    print 'Hello nimei'
#    print 'hahaha'
#else:
#    print 'you are not nimei'
#

## A or B
## A 和 B有一个为True,则为True,其它均为False
#name = raw_input('Please input your name: ')
#age = raw_input('Please input your age: ')
#print type(age)
#if name == 'nimei' or age == '2':
#    print 'Hello nimei'
#    print 'hahaha'
#else:
#    print 'you are not nimei'

## not A 
## 如果A是False,则返回True,表示if 条件成立为True,开始执行if下面代码;
## 反之亦然,即,如果A是True,则返回False,表示if条件不成立,其它elif or else条件成立


## 循环 while,需要有退出的条件
#i = 0
#while i < 20:
#    print i
#    i = i + 1


## 直到用户输入内容才退出,否则一直提示用户输入
#name = ''
#while not name:
#    name = raw_input('Pleae input your name: ')
#
#print 'hello ' + name


## 让用户一直输入数字,如果输入的是'0',终止程序,打印所有输入数字的总和

#一、
#num = 1
#sum = 0
#while num != 0:
#    num = int(raw_input('Please input your number: '))
#    sum = int(sum) + num
#print sum


#二、
#num = ''
#sum = 0
#while num != 0:
#    num = int(raw_input('Please input your number: '))
#    sum = sum + num
#print sum


#三、
#sum = 0
#while True:
#    num = int(raw_input('Please input your number: '))
#    if num == 0:
#        break
#    sum = sum + num
#print sum

#四、
#sum = 0
#while not False:
#    num = raw_input('Please input your number: ')
#    if num == '0':
#        break
#    sum = int(sum) + int(num)
#print sum

#woniu

#num = 0  ## 0是False ''表示空
#while True:
#    i = raw_input('input your number: ')
#    if not i:
#        break
#    num = num + int(i)
#print num


## 让用户一直输入数字(只输入数字),如果没有输入任何值,终止程序;打印所有输入数字的平均值
## woniu    
#num = 0.0
#while True:
#    i = raw_input('input your number: ')
#    if not i:
#        break
#    num = float(i) + num
#print num


#i == ''


## 存10000块钱,年利率是3.25%,求多少年之后,存款能翻番
## 本金+利息
#money = 10000
#year = 0
#while money < 20000:
#    money *= 1.0325
#    year += 1
#print '%s years.the moeny is %s' %(year,money)


## for
## 遍历一个序列并统计序列中js出现的次数
n = 0
p = 0
list2 = ['C', 'js', 'python', 'js', 'css', 'js', 'html', 'node']
for i in list2:
    print i
    if i == 'js':
        n = n + 1
        p += 1
print '%s js count number is: %s' %(p,n)
