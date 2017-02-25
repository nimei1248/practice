def hello(name):
    print 'hello ' + name

def my_hello(fn,name):
    print 'hello world'
    fn(name)
    print 'hello python'

my_hello(hello,'nimei')
