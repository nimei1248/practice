# coding:utf8

#def hello(name):
#    print 'hello ' + name

def my_hello(fn):
    def hello1(name):
        print 'hello world'
        fn(name)
        print 'hello python'
    return hello1

## 1
## 大概过程如下:
## 函数my_hello()接收参数hello(),然后到达函数hello1(),hello1()需要一个函数,但此时没有,继续往下走,
## 变成hello(name),此时变量name是空值,因为函数hello1()没有参数,此时return没有结果,下一步hello1函数接收
## 参数正常返回值
#hello2 = my_hello(hello)
#hello2('nimei')

## 2
#my_hello(hello) 是hello1
#my_hello(hello)('nimei')

## 3
## 装饰器的简写方式,上面1 2的简写方式
@my_hello
def hello(name):
    print 'hello ' + name

hello('nimei')
