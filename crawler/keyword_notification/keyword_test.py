import os
import re
import shutil
import time
from datetime import datetime, timedelta

import pymysql
import requests
from bs4 import BeautifulSoup as bs
from pymysql.constants import CLIENT
from selenium import webdriver
from selenium.webdriver import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys


import os
import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)
from settings import setting


def crawling_cieat():
    # DB 테이블 생성
    cur.execute(f"INSERT INTO keyword_notification (host,title,url) VALUES ('충북대학교','충북대학교 성적장학금 지급 test', 'https://info.cbnu.ac.kr/')")
    cur.execute(f"INSERT INTO keyword_notification (host,title,url) VALUES ('충북대학교','충북대학교 성적 장학금 지급222 test', 'https://info.cbnu.ac.kr/')")
    




if __name__ == '__main__':
    # db 커서 생성
    conn = pymysql.connect(host=setting.host,
                           user=setting.user,
                           password=setting.password,
                           charset='utf8mb4',  # 인코더 다름 주의
                           client_flag=CLIENT.MULTI_STATEMENTS)  # 여러 쿼리문 한번에 가능

    with conn:
        succ = 0
        fail = 0
        with conn.cursor() as cur:
                
                starttime = time.time()
                # db 있으면 버리고 생성
                cur.execute("CREATE DATABASE IF NOT EXISTS `ulife_db`")
                cur.execute("USE ulife_db")

                    # 크롤링 코드 동작
                crawling_cieat()

                # db 저장
                conn.commit()
            
                    