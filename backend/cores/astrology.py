#!/usr/bin/env python3
''' 
    Proudly Written by Yosri. G
    https://Yosri.dev
'''
import requests
from bs4 import BeautifulSoup


def get_astrology(day, month, year):
    '''Astrology base on interactivestars'''
    if int(day) < 10:
        day = '0' + str(int(day))
    if int(month) < 10:
        month = '0' + str(int(month))
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'en-us',
        'Host': 'www.zodiac-astrology-horoscopes.com',
        'Origin': 'http://www.zodiac-astrology-horoscopes.com',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_16) AppleWebKit/605.1.15',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Referer': 'http://www.zodiac-astrology-horoscopes.com/biorhythm.php',
        'Content-Length': '48',
    }
    data = {
      'dobday': day,
      'dobmonth': month,
      'dobyear': year,
      'submit': 'submit'
    }
    url = 'http://www.zodiac-astrology-horoscopes.com/biorhythm.php'
    response = requests.post(
        url,
        headers=headers,
        data=data
    ).text
    begin = response.rfind("<p><strong>Today's")
    end = response.find("More on")
    response = response[begin: end]
    response = response.replace('<br />', '')
    soup = BeautifulSoup(response, features="html.parser")
    paragh = soup.find_all('p')
    motivation = {}
    for order, par in enumerate(paragh[: -1]):
        text = par.getText()
        text = text.replace('\r', '')
        text = text.replace('\n', '')
        text = text.split(':')
        text[0] = '{} {}'.format(order, text[0])
        motivation[text[0]] = text[1]
    return motivation
