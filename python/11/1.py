https://movie.douban.com/top250
https://movie.douban.com/top250?start=0&filter=
https://movie.douban.com/top250?start=25&filter=
https://movie.douban.com/top250?start=50&filter=
https://movie.douban.com/top250?start=75&filter=
.....
https://movie.douban.com/top250?start=225&filter=

0 25 50 75 ... 225

## coding:utf-8
#import requests
#from pyquery import PyQuery as pq
#
#url = 'https://movie.douban.com/top250'
#
#res = requests.get(url)
#d = pq(res.text)
#
#for title in d('.hd'):
#    print pq(title).find('.title').html()


# coding:utf-8
import requests
from pyquery import PyQuery as pq

url = 'https://movie.douban.com/top250'
# >>> range(0,250,25)
#[0, 25, 50, 75, 100, 125, 150, 175, 200, 225]
for i in range(1,11):
    url2 = url + '?start=%s&filter=' % (i * 25)
    res = requests.get(url2)
    d = pq(res.text)

    for title in d('.hd'):
        print pq(title).find('.title').html()
