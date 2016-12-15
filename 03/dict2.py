#!/usr/bin/env python
# -*- coding=utf-8 -*-
# File Name: dict2.py
# Created Time: 2016年12月10日 星期六 14时10分11秒


# my_dict = {"a":1,"b":2}
## 清空
# my_dict.clear()
# my_dict = {}
# print my_dict

## 简单的数据结构赋值给别的变量,是复制的一份,两个变量没有关系,简单数据结构包括:
## 字符串、布尔值,专业词汇要值传递


## 复杂的数据结构,元组、列表、字典赋值

## 获取值 dict.get(key 默认值)
#my_dict = {'name':'xxx'}
#if 'name' in my_dict:
#    print my_dict['name']
#else:
#    print 'no'
#print my_dict.get('name','no')

## 也可以使用setdefault
#get(...)
#    D.et(k[,d]) -> D[k] if k in D, else d.d defaults to None.

#content = '''first of all, i want make it clear that i can not claim understanding this holy book  in just a few weeks, and i #
#'''
#res = {}
#for s in content:
#    ## 1
#    #if s in res:
#    #    res[s] += 1
#    #else:
#    #    res[s] = 0 + 1
#
#    ## 2
#    res[s] = res.get(s,0) + 1
#print res


## fromkeys 快速将list转成一个dict
## list的元素为key,赋一个默认值,字典是无序的
#print {}.fromkeys(['name','age'],'xxx')


#my_dict = {'name':'nimei','type':'python'}
### 获取key的list
#print my_dict.keys()
### 获取value的list
#print my_dict.values()
### 返回由元组组成的列表
#print my_dict.items()

## 查看帮助信息
#print help([].append)
#print help({}.keys)


## popitem 从dict随机弹出值
#my_dict = {'name':'nimei','type':'python'}
#print my_dict.popitem()

## setdefault 设置默认值和get类似
#my_dict = {'name':'nimei','type':'python'}
#my_dict.setdefault('name','xxx')  ## if dict中有值就不会修改,否则就是给dict加值
#my_dict.setdefault('name1','xxx')
#print my_dict


## 文件处理
## 打开文件

## 读文件

## 写文件

## 关闭文件

## 改变文件指针位置
#f = open('user.txt')
## open默认是读的打开方式,如果想写文件,要指明打开的模式,rwa

## read可以读取固定长度的字符,不制定长度的话读到文件结尾
## 所有操作文件的方法,都有一个文件指针的概念
## 每次read都会修改文件指针位置,下次read从指针位置开始
#print f.read(5)
#print f.read(5)
#print f.read()

## readline一次读一行,指针移动到行尾
## print本身打印有换行符
#print f.readline()
#print f.readline(),  ## 加上逗号去除换行符
#print f.readline()


## readlines 一次全部读完,返回一个list,每行是一个元素
#print f.readlines()
## 这个返回的结果中为什么可以看到,可能是因为在list中原因,循环遍历打印就没有了
#list3 = f.readlines()
#for i in list3:
#    print i
#
#f.close()



## open默认是读的打开方式,如果想写文件,要指明打开的模式,rwa
## w模式是覆盖写的,打开文件的时候就把文件清空了
#f = open('user.txt','w')
#f.write('test write')
#f.write('test write\n')  ## 换行写,默认不换行

## a模式是追加写
#f = open('user.txt','a')
#f.write('test write append\n')  ## 换行写,默认不换行
#f.writelines(['xxx\n', 'ddd'])  ## 换行写,默认不换行

## 缓冲概念
## 如果不执行f.flush() or f.close()是不会写到文件中,而是记在缓冲区,默认长度是1024
## 低于这个长度是不会实时写入文件中的
#f.close()
## f.write()不会实时写入文件，clone的时候会自动刷新到文件中

## 注册:
## 让用户输入用户名
## 让用户输入密码
## 如果用户名存在,不允许注册;否则,就添加到文件中,格式是user:password
## 字符串中\n,就会换行

## 方法1
## 让用户输入用户名和密码
## 打开文件
## 读取文件的内容,判断用户名是否存在
## 如果存在:
##     打印错误信息,结束
## 如果不存在:
##     新增内容,写入文件


## 判断字符串是否存在
#In [11]: 'aa' in 'aa'
#Out[11]: True
#
#In [12]: 'a' in 'hhha'
#Out[12]: True

## 下面的写法当文件不存在时是无法将内容写入文件
## 文件存在但为空的时候,也不会写入文件
#f = open('user.txt','a+')
#username = raw_input('Please input your name: ')
#password = raw_input('Please input your password: ')
#
### 文件是空的时候，这个readlines读出来的是空
### 循环是进不去的
#
#for i in f.readlines():
#    print i.split(':')[0]
#    if username in i.split(':')[0]:
#        print '%s is exists, no can register.' % username
#    else:
#        f.write(username + ':' + password + '\n')
#        print '%s register success.' % password
#
#f.close()


## 方法2
## 让用户输入用户名和密码
## 读取文件内容，转成dict
## 通过字典判断用户名是否存在
#username = raw_input('Please input your name: ')
#password = raw_input('Please input your password: ')

## readlines == for 直接遍历 一行行读
username = 'hello'
password = '123'
user_dict = {}
f = open('user.txt','w')
print f.read().split('\n')
for line in f.read().split('\n'):
    print line
    if line:
        temp = line.split(':')
        user_dict[temp[0]] = temp[1]
print user_dict
f.close()

if username in user_dict:
    print 'user exists'
else:
    f = open('user.txt','a')
    f.write(username + ':' + password + '\n')
    f.close()
print user_dict


## 如果修改密码怎么写?
## 输入用户名和密码
## 如果用户名存在,报错
## 存在,修改密码


## 直接遍历文件
#f = open("user.txt")
#for line in f:
#    print line.replace('\n','')

#con = ' ' ##空格是True

## 注意重复问题,作业提交html
## IP       STATUS   COUNT
#   1.1.1.1  200      100
#   1.1.1.1  304      100


#split() == split(' ')

## 判断文件 or 目录是否存在
#In [16]: os.path.isfile('firewall')
#Out[16]: True
#
#In [17]: os.path.exists('firewall')
#Out[17]: True
#
#In [18]: os.path.exists('/root/user')
#Out[18]: True


## 不同数据结构互相转换，不同数据结构的应用场景
## dict hash 原理,hash 碰撞,重复,扩容,一致性hash
## 占内存空间


## set 特点: 存储大量数据,特点是 数据不能重复
## 括号被使用完毕,用函数实现set
## 集合 交集 并集 无顺序




## 函数
## 函数本身是可以传递的,把自己传递给别人
## 函数式编程的基础
## 迭代器/生成器



