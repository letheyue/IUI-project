# -*- coding:utf-8 -*-
import urllib.request
import urllib.error
# A Python 3 demo

class BDTB:
    def __init__(self, baseUrl, seeLZ):
        self.baseURL = baseUrl
        self.seeLZ = '?see_lz=' + str(seeLZ)

    def get_page(self, pageNum):
        try:
            url = self.baseURL + self.seeLZ + '&pn=' + str(pageNum)

            request = urllib.request.Request(url)
            response = urllib.request.urlopen(request)
            print(response.read())
            return response
        except urllib.error.URLError as e:
            if hasattr(e, "reason"):
                print(u"连接百度贴吧失败,错误原因", e.reason)
                return None

if __name__ == '__main__':
    baseURL = 'http://tieba.baidu.com/p/3138733512'
    bdtb = BDTB(baseURL, 1)
    bdtb.get_page(1)
