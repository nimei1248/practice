# coding:utf-8

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

def get_mem_info(arr):
    tmp = arr.split()
    tmp[1] = format_num(tmp[1])
    return tmp[:2]

def operate(key):
    with open('./meminfo.txt') as f:
        mem_total = key(f.readline())
        mem_free = key(f.readline())
        mem_ava = key(f.readline())
        mem_buf = key(f.readline())
        mem_cache = key(f.readline())
        return [mem_total, mem_free, mem_ava, mem_buf, mem_cache]

def get_html(arr):
    html_str = '<table border=1>'
    for mem in arr:
        html_str += '<tr><td>%s</td><td>%s</td></tr>' % tuple(mem)
    html_str += '</table>'
    
    with open('mem.html','w') as f:
        f.write(html_str)

def getMem():
    mem_info = operate(get_mem_info)
    get_html(mem_info)

getMem()
