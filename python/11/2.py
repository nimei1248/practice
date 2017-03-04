import requests
from pyquery import PyQuery as pq

class Crawl:
    def __init__(self):
        self.url = 'https://movie.douban.com/top250?start=%s'
        self.urllist = []
        self.htmllist = []
        self.init_url_list()

    def init_url_list(self):
        for i in range(0,250,25):
            self.urllist.append(self.url%(i))

    def html_downloader(self):
        for url in self.urllist:
            r = requests.get(url)
            self.htmllist.append(r.text)

    def html_parser(self):
        for content in self.htmllist:
            for t in pq(content)('.hd'):
                print pq(t).find('.title').html()

    def start(self):
        self.html_downloader()
        self.html_parser()


c = Crawl()
#c.start()
c.init_url_list()




#url = 'https://movie.douban.com/top250'
#res = requests.get(url)
#print res.text

#d = pq(res.text)

#for title in d('.title'):
#    print pq(title).html()
