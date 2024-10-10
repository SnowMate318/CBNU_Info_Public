import re

import pymysql
import scrapy
from pymysql.constants import CLIENT
from scrapy.crawler import CrawlerProcess

import menu_crawler_sele
import menu_items
import menu_query

import os
import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)
from settings import setting

# 기숙사식당 크롤링 (scrapy)
class MenuSpider(scrapy.Spider):
    name = "menu"

    def start_requests(self):

        # 저장할 데이터베이스 생성
        cur.execute(menu_query.create_menu_tb)

        for idx in range(1, 4):

            url = f'https://dorm.chungbuk.ac.kr/home/sub.php?menukey=20041&type={idx}'

            # 식당이름 받기
            if idx == 1:
                cafeteria_name = '본관'
            elif idx == 2:
                cafeteria_name = '양성재'
            else:
                cafeteria_name = '양진재'

            yield scrapy.Request(url=url, callback=self.parse, meta={'cafeteria_name': cafeteria_name})

    def parse(self, response, **kwargs):

        # 날짜객체 받기
        day_list = response.xpath('/html/body/div/div[5]/div[2]/div/div[2]/div[2]/table[1]/tbody/tr')

        for day in day_list:

            try:
                menu_date = day.css('td.foodday::text').getall()[1]  # 날짜
                weekday = day.css('td.foodday::text').getall()[0]  # 요일

            except:  # red 태그 붙은경우
                menu_date = day.css('td.foodday > strong::text').getall()[1]
                weekday = day.css('td.foodday > strong::text').getall()[0]

            morning_food_list = day.css('td.morning::text').getall()
            lunch_food_list = day.css('td.lunch::text').getall()
            evening_food_list = day.css('td.evening::text').getall()

            food_lists = [morning_food_list, lunch_food_list, evening_food_list]

            for idx, food_list in enumerate(food_lists):

                # 식사시간
                if idx == 0:
                    food_time = '아침'
                elif idx == 1:
                    food_time = '점심'
                else:
                    food_time = '저녁'

                for food_name in food_list:
                    # 아이템 객체 생성
                    item = menu_items.MenuItem()

                    # 날짜,메뉴타임,식당이름,음식이름
                    item['menu_date'] = menu_date
                    item['food_time'] = food_time
                    item['cafeteria_name'] = response.meta['cafeteria_name']
                    item['food_name'] = food_name

                    # 문자열 파싱
                    item['food_name'] = re.sub(r'\n| ', '', item['food_name']) # 개행문자,띄어쓰기 제거
                    if item['food_name'] == '':
                        continue

                    cur.execute(
                        f"INSERT INTO food (menu_date, food_time, cafeteria_name, food_name) VALUES ('{item['menu_date']}', '{item['food_time']}', '{item['cafeteria_name']}', '{item['food_name']}')")


if __name__ == "__main__":
    # db 커서 생성
    conn = pymysql.connect(host=setting.host,
                           user=setting.user,
                           password=setting.password,
                           charset='utf8',
                           client_flag=CLIENT.MULTI_STATEMENTS)  # 여러 쿼리문 한번에 가능

    with conn:
        with conn.cursor() as cur:

            cur.execute("CREATE DATABASE IF NOT EXISTS `ulife_db`")
            cur.execute("USE ulife_db")

            # 크롤링 코드 동작, spider 안에 데이터 추가 구현

            process = CrawlerProcess()
            process.crawl(MenuSpider)
            process.start()

            menu_crawler_sele.crawling_menu(cur)
            
            # 중복제거
            cur.execute(menu_query.romove_dupl)

            # db 저장
            conn.commit()
