def hello(name):
    print 'hello ' + name

def my_hello(fn):
    def hello1(name):
        print 'hello world'
        fn(name)
        print 'hello python'
    return hello1

## 1
#hello2 = my_hello(hello)
#print hello2
#print hello2()
#print hello2('1111')
#hello2('nimei')

## 2
#my_hello(hello)('nimei')
