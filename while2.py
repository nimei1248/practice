#coding: utf8

## while循环,需要有退出的条件
#i = 0
#while i <= 20:
#    print i
#    i = i + 1


## 直到用户输入内容才退出,否则一直提示用户输入
#name = ''         ## 定义变量name的初始值为空值'',空值按照bool type规则是False
#print type(name)  ## 字符串类型
#while not name:   ## not取反,name = False,取反为True,这样while语句的条件一直为真,会一直循环;直到name的值是非空
#                  ## name的值非空时,相当于name = True,not取反就是while语句的条件为False,执行完语句后就退出循环
#                  ## 可以用while name: print 1、while not name: print 1测试验证,while只有条件为True,才会执行循环体
#                  ## 因为不同类型比较结果均为False(除01),不管是否为空值,如果是这样的话,not False = True,会一直循环,结合上面点不会
#    print type(name)
#    name = raw_input('Please input your name: ')
#    print type(name)  ## 捕捉回车键是字符串类型 str
#    print len(name)   ## 回车键是空字符串相当于'',长度为0
#
#print 'Hello ' + name


## 让用户一直输入数字,如果输入的是'0',终止程序,打印所有输入数字的总和
## 数字包括整数 + 实数
#num = 0  ## 0是False
#
#while True:
#    try:
#        i = float(raw_input('Please input your number: '))  ## 字符串不能转成浮点数
#        print type(i)
#    except ValueError:  ## 当用户输入字符串后,如果不做异常处理,程序就会退出
#        print 'Can not input strings'
#        continue   ## 这里加入continue,表示当用户输入的是字符串时,跳过此次循环进入下一次循环
#                   ## 否则字符串会被当成浮点数+1,num = i + num
#        print
#    else:
#        if not i:  ## 由于0是False,当输入0时取反为True,if条件成立就会执行break语句
#            break
#
#    num = i + num
#    print num
#
#print num



## 让用户一直输入数字(只输入数字),如果没有输入任何值,终止程序;打印所有输入数字的平均值
## 平均数求值: 有多少个数字求平均,就除以多少个数
#num = 0  ## 0是False
#n = 0
#
#while True:
#    try:
#        i = float(raw_input('Please input your number: '))  ## 字符串不能转成浮点数
#    except ValueError:  ## 当用户输入字符串后,如果不做异常处理,程序就会退出
#        print 'Can not input strings'
#        continue   ## 这里加入continue,表示当用户输入的是字符串时,跳过此次循环进入下一次循环
#                   ## 否则字符串会被当成浮点数+1,num = i + num
#        print
#    else:
#        if not i:  ## 由于0是False,当输入0时取反为True,if条件成立就会执行break语句
#        #if i:     ## 由于0是False,当输入0时取反为True,if条件成立就会执行break语句
#            break
#
#    num = i + num
#    n = n + 1
#
#if n != 0:
#    print "argv: %s" %(num / n)



## 存10000块钱,年利率是3.25%,求多少年之后,存款能翻番
## 本金10000,当利息也达到10000,就表示翻一倍
## 本次前提是年利率不变,按照年利率算,不考虑活期、死期情况、利息收税、外币存储利率等

## 利息 = 本金 * 存期 * 利率

## 第1年本金+利息,作为第2年本金,依次类推,俗称利滚利

## 第1年利息 = 本金  * 存期 * 年利率
#     325    = 10000 * 1 * 0.0325
## 第1年本金 + 利息 = 10000 + 第1年利息
#     10325  = 10000 + 325
#              10000 + (10000 * 1 * 0.0325)
#              10000 + (10000 * 0.0325)
#              10000 * (1 + 0.0325)
#              10000 + (10000 * 0.0325)

## 第2年利息 = (第1年本金 + 利息) * 存期 * 年利率
#  335.5625  = (10000 + 325) * 1 * 0.0325
## 第2年本金 + 利息 = (10000 + 325) + 第2年利息
# 10335.5625 = (10000 + 325) + 335.5625
#              (10000 + 325) + ((10000 + (10000 * 1 * 0.0325)) * 1 * 0.0325)
#              (10000 + 325) + (10000 * (1 + 0.0325) * 1 * 0.0325)
#              (10000 + 325) + (10000 * (1 + 0.0325) * 0.0325)
#              (10000 + 325) + (10000 * 1.0325 * 0.0325)

## 依次类推


money = 10000
year = 0

while money <= 20000:
    print "before: %s" % money
    #money *= 1.0325  ## 公式合写/简写
    #money = money * 1.0325
    money = money + (money * 0.0325 * 1)

    year += 1

    print "after: %s" % money
    print

print '%s years after the money is %s' %(year, money)
