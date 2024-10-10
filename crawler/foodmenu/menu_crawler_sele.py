import re
from datetime import datetime

import pandas as pd
import pymysql
from pymysql.constants import CLIENT
from selenium import webdriver
from selenium.webdriver.common.by import By

import menu_query

import os
import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)
from settings import setting


def crawling_menu(cur):
    # 저장할 데이터베이스 생성
    cur.execute(menu_query.create_menu_tb)

    # 크롤링
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument("--window-size=1920,1080")  # 화면크기(전체화면)
    options.add_experimental_option("excludeSwitches", ['enable-automation'])
    options.add_argument("--disable-infobars")

    driver = webdriver.Chrome(options=options)

    # 식당 페이지 열기
    driver.get('https://www.cbnucoop.com/service/restaurant/?week=0')
    driver.implicitly_wait(5)

    # 날짜 데이터 받기, 파싱
    date_str = driver.find_element(By.CSS_SELECTOR, '#menu-type-title').text
    date_str = re.findall(r"\d+년 \d+월 \d+일", date_str)

    # 날짜데이터 생성
    for cafeteria_idx, day in enumerate(date_str):
        date_str[cafeteria_idx] = datetime.strptime(date_str[cafeteria_idx], '%Y년 %m월 %d일')

    dates = pd.date_range(start=date_str[0], end=date_str[1], freq='D')

    for cafeteria_idx in range(0, 3):
        # 한빛식당
        if cafeteria_idx == 0:
            driver.find_element(By.XPATH, '/html/body/div/section/div/div[2]/div/div[2]/nav/a[1]').click()
            driver.implicitly_wait(5)

            hanbit_morning_lists = driver.find_elements(By.XPATH,
                                                        '/html/body/div/section/div/div[2]/div/div[3]/div[1]/div/table/tbody/tr[2]/td')
            hanbit_lunch_lists = driver.find_elements(By.XPATH,
                                                      '/html/body/div/section/div/div[2]/div/div[3]/div[1]/div/table/tbody/tr[4]/td')
            hanbit_dinner_lists = driver.find_elements(By.XPATH,
                                                       '/html/body/div/section/div/div[2]/div/div[3]/div[1]/div/table/tbody/tr[6]/td')

            cafeteria = [hanbit_morning_lists, hanbit_lunch_lists, hanbit_dinner_lists]

        # 별빛 식당
        if cafeteria_idx == 1:
            driver.find_element(By.XPATH, '/html/body/div/section/div/div[2]/div/div[2]/nav/a[2]').click()
            driver.implicitly_wait(5)

            byulbit_lunch_lists = driver.find_elements(By.XPATH,
                                                       '/html/body/div/section/div/div[2]/div/div[3]/div[2]/div/table/tbody/tr[2]/td')

            cafeteria = [byulbit_lunch_lists]

        # 은하수 식당
        if cafeteria_idx == 2:
            driver.find_element(By.XPATH, '/html/body/div/section/div/div[2]/div/div[2]/nav/a[3]').click()
            driver.implicitly_wait(5)

            eunhasu_lunch_lists = driver.find_elements(By.XPATH,
                                                       '/html/body/div/section/div/div[2]/div/div[3]/div[3]/div/table/tbody/tr[2]/td')
            eunhasu_dinner_lists = driver.find_elements(By.XPATH,
                                                        '/html/body/div/section/div/div[2]/div/div[3]/div[3]/div/table/tbody/tr[4]/td')

            cafeteria = [eunhasu_lunch_lists, eunhasu_dinner_lists]

        for food_time_idx, week_menu in enumerate(cafeteria):  # idx2 : 아침점심저녁

            # 식당이름, 식사시간 분류
            if cafeteria_idx == 0:
                cafeteria_name = '한빛식당'

                if food_time_idx == 0:
                    food_time = '아점'
                elif food_time_idx == 1:
                    food_time = '점심'
                else:
                    food_time = '저녁'

            if cafeteria_idx == 1:
                cafeteria_name = '별빛식당'
                food_time = '점심'

            if cafeteria_idx == 2:
                cafeteria_name = '은하수식당'

                if food_time_idx == 0:
                    food_time = '점심'
                elif food_time_idx == 1:
                    food_time = '저녁'

            # 메뉴 리스트
            for day_idx, food_list in enumerate(week_menu):

                menu_date = dates[day_idx]
                # menu_date = datetime.strptime(dates[day_idx].isoformat(),'%Y-%m-%dT%H:%M:%S').date()

                food_list = food_list.text
                food_list = food_list.split('\n')
                food_list = [food for food in food_list if '￦' not in food]

                for food_name in food_list:

                    if food_name == '':
                        continue

                    cur.execute(
                        f"INSERT INTO food (menu_date, food_time, cafeteria_name, food_name) VALUES ('{menu_date}', '{food_time}', '{cafeteria_name}', '{food_name}')")


# if __name__ == "__main__":
#     conn = pymysql.connect(host=setting.host,
#                            user=setting.user,
#                            password=setting.password,
#                            charset='utf8',
#                            client_flag=CLIENT.MULTI_STATEMENTS)  # 여러 쿼리문 한번에 가능

#     with conn:
#         with conn.cursor() as cur:
#             # db 있으면 버리고 생성
#             cur.execute("DROP DATABASE IF EXISTS `ulife_db`")
#             cur.execute("CREATE DATABASE `ulife_db`")
#             cur.execute("USE ulife_db")

#             # 크롤링 코드 동작, spider 안에 데이터 추가 구현
#             crawling_menu(cur)

#             # db 저장
#             conn.commit()
