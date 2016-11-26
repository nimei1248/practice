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
#   ...
#else 条件为False
#   ...
#
#单个=号是赋值,双==号是判断

name = raw_input('Please input your name: ')
if name == 'nimei':
    print 'Hello nimei'
    print 'hahaha'

print 'not if in'
