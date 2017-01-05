# coding:utf-8

## 此脚本功能用于实现系统内存获取展示


## 对函数get_mem_info()的小列表元素进行处理,条件判断后,进行字符串拼接,再返回给函数get_mem_info()
def format_num(num):
    num = int(num)
    o = 'KB'
    if num > (1024 * 1024):
        num /= (1024 * 1024.0)
        o = 'GB'
    elif num > 1024:
        num /= 1024.0
        o = 'MB'
    return '%.2f%s' % (num,o)


## 函数get_mem_info()对字符串进行分割,形成list,再对list的元素重新赋值,返回处理后的小列表给函数operate()
def get_mem_info(arr):
    tmp = arr.split()
    tmp[1] = format_num(tmp[1])
    return tmp[:2]


## 函数operate()打开文件后,读取一行内容作为函数get_mem_info()的参数,交给函数get_mem_info()处理
## 函数get_mem_info()将字符串分割成列表,再通过函数format_num()将list的元素2做处理后赋值给list元素2,
## 然后以列表形式返回相应的变量,如,mem_total = ['MemTotal:', '15.51GB'] 
## operate()函数组成新的列表返回给函数get_html()进行处理
def operate(key):
    with open('/proc/meminfo') as f:
        mem_total = key(f.readline())
        mem_free = key(f.readline())
        mem_ava = key(f.readline())
        mem_buf = key(f.readline())
        mem_cache = key(f.readline())
        return [mem_total, mem_free, mem_ava, mem_buf, mem_cache]


## 对函数operate()返回的list进行循环,将循环的小列表元素转成元组赋值给html,最后是写html到文件
def get_html(arr):
    html_str = '<table border=1>'
    for mem in arr:
        #html_str += '<tr><td>%s</td><td>%s</td></tr>' % (mem[0],mem[1])
        html_str += '<tr><td>%s</td><td>%s</td></tr>' % tuple(mem)
    html_str += '</table>'
    
    with open('mem.html','w') as f:
        f.write(html_str)

    return html_str


## 入口函数
def getMem():
    mem_info = operate(get_mem_info)  ## 将函数get_mem_info()传递给入口函数operate()
    return get_html(mem_info)  ## 将入口函数operate()处理结果(为list),通过return返回传递给函数get_html()


getMem()
