#coding: utf8

## break语句可以跳出for、while循环,跳出哪个循环,由代码缩进决定

## 从0打印到7时,停止 break
## 因为i = i + 1位置原因,从0-7都会打印,看不出break效果,面一个实例就可以看出
#i = 0
#while i < 10:
#    print i
#    if i == 7:
#        break
#    i = i + 1


## 从0打印到6时,停止 break
#i = 0
#while i < 10:
#    print i
#    i = i + 1
#    if i == 7:
#        break


## 0打印到9时,当i=7时,跳过此次循环 continue
## 因为print函数存在的位置,从0-9都会打印,看不出continue效果,下面一个实例就可以看出
#i = 0
#while i < 10:
#    print i
#    i = i + 1
#    if i == 7:
#        continue


## 当i=7时,跳过此次循环 continue
#i = 0
#while i < 10:
#    i = i + 1
#    if i == 7:
#        continue
#    print i


## 判断是否为闰年
## 用户输入数字,判断是不是闰年:
## 如果是100的倍数,要被400整除,是闰年
## 如果不能被100整除,可以被4整除,是闰年
## 如1900不是闰年,2000,2004是闰年
## 如果输入不是闰年,提示信息,并继续输入

#while True:
#    try:
#        num = int(raw_input('Please input number: '))
#    except ValueError:
#        print 'Can not enter string!'
#    else:
#        if num % 100 == 0 and num % 400 == 0:
#	    print '%s is leap year.' % num
#	elif num % 100 != 0 and num % 4 == 0:
#	    print '%s is leap year.' % num
#	else:
#	    print '%s is not leap year.' % num


## based on the above code to do optimization 
msg = '%s is leap year.'
while True:
    try:
        num = int(raw_input('Please input number: '))
    except ValueError:
        print 'Can not enter string!'
    else:
        if num % 400 == 0:  ## 能被400整除,也就能被100整除
	    print msg % num
	elif num % 100 != 0 and num % 4 == 0:
	    print msg % num
	else:
	    print '%s is not leap year.' % num
