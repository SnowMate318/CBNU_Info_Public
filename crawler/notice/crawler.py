import logging
from datetime import datetime, timedelta

import scrapy
from scrapy import signals
from scrapy.http import HtmlResponse
from scrapy.signalmanager import dispatcher
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

import func
import options
import queries


class NoticeSpider(scrapy.Spider):
    name = 'notice_spider'

    def __init__(self, cur, class_dicts, *args, **kwargs):
        super(NoticeSpider, self).__init__(*args, **kwargs)
        self.cur = cur
        self.crawled_data = dict()
        self.insert_data = dict()
        self.class_dicts = class_dicts
        self.pending_requests = {}
        self.insert_counts = {major: 0 for major in class_dicts}  # 학과별 삽입된 데이터 수를 저장할 딕셔너리
        self.cur.execute(queries.return_query(action='CREATE_TABLE'))

        # Selenium 설정
        chrome_options = Options()
        chrome_options.add_argument('--headless')
        chrome_options.add_argument('--disable-gpu')
        chrome_options.add_argument('--no-sandbox')
        # chrome_options.add_argument('--disable-extensions')  # 확장 프로그램 비활성화
        # chrome_options.add_argument('--disable-infobars')  # 자동화 메시지 비활성화
        # chrome_options.add_argument('--disable-browser-side-navigation')  # 브라우저 측 내비게이션 비활성화
        # chrome_options.add_argument('--disable-blink-features=AutomationControlled')  # 자동화 제어 비활성화
        # chrome_options.add_argument('--blink-settings=imagesEnabled=false') # 이미지 로드 비활성화
        # # 임의의 User-Agent 설정
        # user_agent = "Mozilla/5.0 (Linux; Android 9; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.83 Mobile Safari/537.36"
        # chrome_options.add_argument(f'user-agent={user_agent}')

        self.driver = webdriver.Chrome(options=chrome_options)

    def start_requests(self):
        for major in self.class_dicts:
            logging.info(f'{major} start')
            self.crawled_data[major] = []
            self.insert_data[major] = []
            board_url = self.class_dicts[major]['main_url'] + str(
                self.class_dicts[major].get('start_page', options.START_PAGE))

            yield scrapy.Request(board_url, self.parse, meta={'major': major})

    def parse(self, response, **kwargs):
        major = response.meta['major']
        class_data = self.class_dicts[major]
        self.crawled_data[major].clear()

        start_page = class_data['start_page']
        end_page = class_data['end_page']
        current_page = response.meta.get('next_page', start_page)
        next_page = current_page + 1

        post_tag = class_data.get('art_tag')
        post_url_tag = class_data.get('artUrlSubTag')
        post_nid_tag = class_data.get('art_nid_tag')
        post_title_tag = class_data.get('page_title_tag')
        post_date_tag = class_data.get('page_date_tag')

        # 게시물 객체 받기
        post_list = response.css(post_tag)  # selector 객체 리스트, get/getall 은 selector 객체를 텍스트로 변환함
        # 동적페이지인 경우
        if not post_list:
            # Selenium에서 가져온 페이지 소스로 HtmlResponse 객체 생성
            response = self.request_by_selenium(response, post_tag)
            post_list = response.css(post_tag)

            # # 디버깅용
            # if post_list:
            #     logging.info(f'셀레니움 : {major}')
            # else:
            #     logging.info(f'셀레니움 해도 안됨 : {major}')

        error_cnt = 0
        self.pending_requests[major] = len(post_list)
        for idx, post in enumerate(post_list):
            try:
                post_url = response.urljoin(post.css(post_url_tag).attrib['href'])  # 절대경로 추출
                nid = func.filter_valid_texts(post.css(post_nid_tag + ' *::text').getall()) or '공지'  # 공지가 이미지여서 빈문자열일떄
                title = func.filter_valid_texts(post.css(post_title_tag + ' *::text').getall())
                date = func.filter_valid_texts(post.css(post_date_tag + ' *::text').getall())
            except (ValueError, KeyError):
                error_cnt += 1
                self.pending_requests[major] -= 1

                # 중지 체크
                if self.pending_requests[major] == 0:
                    yield from self.finalize(major, current_page, next_page, end_page)
                # 끝페이지여서 게시글 없는경우
                if error_cnt == len(post_list):
                    yield from self.finalize(major, current_page, next_page, end_page, stop=True)

                continue

            yield response.follow(post_url, self.parse_post,
                                  meta={'major': major, 'nid': nid, 'title': title, 'date': date, 'url': post_url,
                                        'current_page': current_page, 'next_page': next_page, 'end_page': end_page,
                                        'idx': idx},
                                  dont_filter=True  # 중복필터 사용안함
                                  )

    def parse_post(self, response):

        major = response.meta['major']
        nid = response.meta['nid']
        page_title = response.meta['title']
        page_date = response.meta['date']
        url = response.meta['url']

        current_page = response.meta['current_page']
        next_page = response.meta['next_page']
        end_page = response.meta['end_page']

        post_title_in_tag = self.class_dicts[major].get('art_title_tag')
        post_date_in_tag = self.class_dicts[major].get('art_date_tag')

        title_in_post = func.filter_valid_texts(
            response.css(post_title_in_tag + '::text').getall()) if post_title_in_tag else None
        date_in_post = func.filter_valid_texts(
            response.css(post_date_in_tag + '::text').getall()) if post_date_in_tag else None

        # 이거 키면 페이지 내부 요청 안함
        title = title_in_post or page_title  # 내부 제목 없으면 글 밖에서 크롤링한 제목 가져오기
        date = date_in_post or page_date

        # 동적페이지인 경우
        if not title or not date:
            response = self.request_by_selenium(response, post_title_in_tag)
            title_in_post = func.filter_valid_texts(
                response.css(post_title_in_tag + '::text').getall()) if post_title_in_tag else None
            title = title_in_post or page_title  # 내부 제목 없으면 글 밖에서 크롤링한 제목 가져오기
            date_in_post = func.filter_valid_texts(
                response.css(post_date_in_tag + '::text').getall()) if post_date_in_tag else None
            date = date_in_post or page_date

        if not title:
            logging.error('title None')
        elif not date:
            logging.error('date None')

        # 전처리
        title = func.parse_title(title)
        date = func.parse_date(date)
        # 크롤링 데이터에 삽입
        post_data = [major, nid, title, url, date]
        self.crawled_data[major].append(post_data)

        # 크롤링 카운트, 페이지 크롤링 끝나면 동작
        self.pending_requests[major] -= 1
        if self.pending_requests[major] == 0:
            yield from self.finalize(major, current_page, next_page,
                                     end_page)

    def check_duplicate(self, major):
        # DB 에서 가장 최신 데이터 조회
        try:
            self.cur.execute(queries.return_query(major=major, action='GET_LATEST_POST'))
            latest_post = self.cur.fetchone()
            if latest_post is None:
                # DB에 최신 게시물이 없는 경우
                latest_post_idx = None
                latest_post_nid = None
                latest_post_title = None
                latest_post_date = datetime.min  # 가장 오래된 날짜로 설정
                latest_post_url = None
            else:
                latest_post_idx = latest_post[0]
                latest_post_nid = latest_post[2]
                latest_post_title = latest_post[3]
                latest_post_date = latest_post[5]
                latest_post_url = latest_post[4]
        except Exception as e:
            logging.error(f"DB 예외 발생: {e}")
            latest_post_idx = None
            latest_post_nid = None
            latest_post_title = None
            latest_post_date = datetime.min  # 가장 오래된 날짜로 설정
            latest_post_url = None

        # 중복체크
        crawled_data_list = self.crawled_data[major]
        self.crawled_data[major].sort(key=lambda x: x[4])  # date 순으로 정렬, 최신이 맨 아래
        is_duplicate = False

        for data in crawled_data_list:
            # 목표기간보다 오래된 경우
            target_time = datetime.now() - timedelta(days=self.class_dicts[major]['target_timedelta_year'] * 365)
            if data[4] <= target_time:
                if data[1].isdigit():  # 공지 아니면 크롤링 중단
                    is_duplicate = True
                    logging.info(f"Skipping old post: {data}")
                else:
                    logging.info(f"Skipping old notice post: {data}")
                continue
            # 최신 게시글보다 오래된 경우
            if data[4] < latest_post_date:
                if data[1].isdigit():
                    is_duplicate = True
                    logging.info(f"Skipping older post: {data}")
                else:
                    logging.info(f"Skipping older notice post: {data}")
                continue
            # 삽입리스트에 추가
            self.insert_data[major].append(data)

        return is_duplicate

    def check_end_page(self, current_page, end_page):
        if current_page == end_page:
            return True

    def request_by_selenium(self, response, wait_data_tags=None):
        # 동적 페이지 처리
        self.driver.get(response.url)
        if wait_data_tags:
            try:
                # 특정 요소가 로드될 때까지 기다림 (예: 게시물 리스트 테이블)
                WebDriverWait(self.driver, options.WAITTIME).until(
                    EC.presence_of_all_elements_located((By.CSS_SELECTOR, wait_data_tags))
                )
            except TimeoutError:
                logging.error("Timed out waiting for page to load")
                return None
        else:
            self.driver.implicitly_wait(options.WAITTIME)  # 필요에 따라 조정
        # 추가로 JavaScript 실행이 완료될 때까지 기다림
        try:
            WebDriverWait(self.driver, options.WAITTIME).until(
                lambda driver: driver.execute_script('return document.readyState') == 'complete'
            )

        except TimeoutError:
            logging.error("Timed out waiting for page to load")
            return None

        # Selenium에서 가져온 페이지 소스로 HtmlResponse 객체 생성
        selenium_response = HtmlResponse(
            url=response.url,
            body=self.driver.page_source,
            encoding='utf-8',
            request=response.request
        )

        return selenium_response

    def insert_db(self, major):
        for data in self.insert_data[major]:
            self.cur.execute(
                f"INSERT INTO notice (major,nid,title,url,date_post) VALUES ('{data[0]}','{data[1]}','{data[2]}','{data[3]}','{data[4]}')")
            logging.info(f"Inserted into DB: major={data[0]}, title={data[2]}, url={data[3]}")
            self.insert_counts[major] += 1  # 삽입된 데이터 수 증가

        logging.info(f"All data for {major} have been processed.")

    def finalize(self, major, current_page, next_page, end_page, stop=False):
        # 중복체크, 중지 체크
        is_duplicate = self.check_duplicate(major)
        is_end_page = self.check_end_page(current_page, end_page)
        # 중지 or 진행
        if not is_duplicate and not is_end_page and not stop:
            next_url = self.class_dicts[major]['main_url'] + str(next_page)
            yield scrapy.Request(next_url, self.parse, meta={'major': major, 'next_page': next_page})
        else:
            self.insert_db(major)

    def close(self, reason):
        self.driver.quit()
        for major in self.insert_counts.keys():
            logging.info(f"Total inserted records for {major}: {self.insert_counts[major]}")  # 학과별 삽입된 데이터 수 로그

    def spider_closed(self, spider):  # 디버깅중 강제종료 하는 경우
        logging.info("Closing ChromeDriver...")
        self.driver.quit()
