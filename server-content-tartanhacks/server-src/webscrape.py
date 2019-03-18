from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup

import urllib.request
from selenium import webdriver


def simple_get (url):
    try:
        with closing (get (url, stream = True)) as resp:
            if is_good_response (resp):
                return resp.content
            else:
                return None
    except RequestException as e:
        log_error ('Error loggin to requests to {0} : {1}'.format(url, str(e)))
        return None
        
def is_good_response (resp):
    content_type = resp.headers["Content-Type"].lower()
    return ((resp.status_code == 200 or resp.status_code == 999)
        and content_type is not None
        and content_type.find ('html') > -1)
        
        
def log_error (e):
    print (e)
    
    #takes a url from linked or github or sthg and returns some detail from that website
def getDetails (url):
    raw_html = simple_get (url)
    d = {}
    if url.find ('github.com')>-1:#check which kind of url
        html = BeautifulSoup (raw_html, 'html.parser')
        for s in html.select ("span"): #get title of first pinned repository
            if s.has_attr ('title') and s.has_attr ('class'):
                key = s['title']
                break
        for p in html.select ('p'):
            if p.has_attr('class') and ('pinned-repo-desc' in p['class']):
                d [key] = p.text.strip()
                return list(d) + [(d[key])]
        return ["no pinned repositories", None]



print (getDetails ("https://github.com/EdwardLu2018"))
