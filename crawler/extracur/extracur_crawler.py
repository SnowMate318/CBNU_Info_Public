import json
import os
import shutil

import pymysql
import requests
import scrapy
from pymysql.constants import CLIENT
from scrapy.crawler import CrawlerProcess

import extracur_query as query

import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)
from settings import setting
from keyword_notification import keyword_query as keyword

class AllforyoungSpider(scrapy.Spider):
    name = 'allforyoung'
    sitemap_urls = ['https://allforyoung.com/server-sitemap.xml']

    def start_requests(self):
        print('대외활동 크롤러 시작')

        # DB 테이블 생성
        cur.execute(query.create_post_tb)

        for url in self.sitemap_urls:
            yield scrapy.Request(url=url, callback=self.parse_sitemap)

    def parse_sitemap(self, response):
        for loc in response.xpath('//sitemap:loc/text()',
                                  namespaces={'sitemap': 'http://www.sitemaps.org/schemas/sitemap/0.9'}):
            post_url = loc.get()

            # 포스트만 가져오기
            if 'post' not in post_url:
                continue

            yield scrapy.Request(url=post_url, callback=self.parse, meta={'url': post_url})

    def parse(self, response, **kwargs):
        script_tag = response.css('script#__NEXT_DATA__')
        json_data = script_tag.xpath('./text()').get()
        data_dict = json.loads(json_data)
        post_data = data_dict["props"]["pageProps"]["post"]["data"]

        post_category = post_data["post_category"]  # 카테고리(국비,공모전,대외활동)
        post_category_sub = post_data["tags"][0]["name"]  # 카테고리2(IT/논문 등)

        post_url = response.meta['url']  # 공고 링크
        post_id = int(post_data["id"])  # 글번호 (int 변환)
        post_title = post_data["name"]  # 제목
        post_organization = post_data["organization"]  # 주최
        post_startdate = post_data["recruitment_startdate"]  # 모집 시작 날짜
        post_closingdate = post_data["recruitment_closingdate"]  # 모집 종료 날짜
        post_apply_url = post_data["apply"]  # 접수 링크
        post_hits = post_data["hits"]  # 조회수

        post_img = post_data["photos"][0]
        post_img_url = post_img["img_file"]  # 이미지 url
        post_img_thumbnail_url = post_img["thumbnail_file"]  # 썸네일 url

        # 이미지 저장
        # 이미지 디렉토리 경로 생성
        script_directory = os.path.dirname(os.path.abspath(__file__))
        directory_path = os.path.join(script_directory, "images")
        if not os.path.exists(directory_path):
            os.makedirs(directory_path)

        img_filename = str(post_id) + '.jpg'
        img_response = requests.get(post_img_url)
        img_filepath = os.path.join(directory_path, img_filename)  # 이미지 경로
        with open(img_filepath, "wb") as f:
            f.write(img_response.content)

        img_thumbnail_filename = str(post_id) + ' thumb' + '.png'
        img_thumbnail_response = requests.get(post_img_thumbnail_url)
        img_thumbnail_filepath = os.path.join(directory_path, img_thumbnail_filename)  # 썸네일 이미지 경로
        with open(img_thumbnail_filepath, "wb") as f:
            f.write(img_thumbnail_response.content)

        # DB 추가
        

        val = ('씨앗', post_title, post_url)
        cur.execute(keyword.insert_keyword, val)
                    
        print(f"키워드 db 추가완료: host: 씨앗, title: {post_title}, url: {post_url}")  
            
        val = (post_category, post_category_sub, post_url, post_id, post_title, post_organization,
               post_startdate, post_closingdate, post_apply_url, post_hits, post_img_url, img_filepath,
               post_img_thumbnail_url, img_thumbnail_filepath)
        cur.execute(query.insert_post, val)


if __name__ == "__main__":
    # db 커서 생성
    conn = pymysql.connect(host=setting.host,
                           user=setting.user,
                           password=setting.password,
                           charset='utf8mb4',  # 인코더 다름 주의
                           client_flag=CLIENT.MULTI_STATEMENTS)  # 여러 쿼리문 한번에 가능

    with conn:
        with conn.cursor() as cur:
            # db 있으면 버리고 생성
            cur.execute("CREATE DATABASE IF NOT EXISTS `ulife_db`")
            cur.execute("USE ulife_db")

            # 디렉토리 존재하면 삭제
            script_directory = os.path.dirname(os.path.abspath(__file__))
            directory_path = os.path.join(script_directory, "images")
            if os.path.exists(directory_path):
                shutil.rmtree(directory_path)

            # 크롤링 코드 동작
            process = CrawlerProcess()
            process.crawl(AllforyoungSpider)
            process.start()

            # db 저장
            conn.commit()
