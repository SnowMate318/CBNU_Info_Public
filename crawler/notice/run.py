import os
import sys
import pymysql
from pymysql.constants import CLIENT
from scrapy.utils.log import configure_logging
from classList import *
from logging.handlers import RotatingFileHandler
import time
import logging
from scrapy.crawler import CrawlerProcess
from crawler import NoticeSpider
from datetime import datetime

script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)
from settings import setting
import queries

# 실행 시작 시간 기록
start_time = datetime.now()
start_time_str = start_time.strftime("%Y%m%d_%H%M%S")

# 로그 파일 설정
# 로그 디렉토리 설정
log_dir = os.path.join(script_dir, 'log')
os.makedirs(log_dir, exist_ok=True)

# 로그 파일 설정
log_filename = ''
if test_dicts:
    log_filename = os.path.join(log_dir, f'scrapy_log_{start_time_str}_test.txt')
else:
    log_filename = os.path.join(log_dir, f'scrapy_log_{start_time_str}.txt')


log_handler = RotatingFileHandler(log_filename, maxBytes=10**7, backupCount=5, encoding='utf-8')
logging.basicConfig(
    handlers=[log_handler],
    format='%(asctime)s [%(levelname)s] %(message)s',
    level=logging.INFO  # 전체 로그 레벨 설정 (DEBUG, INFO, WARNING, ERROR, CRITICAL)
)

# Scrapy 로그 레벨 설정
configure_logging(install_root_handler=False)
logging.getLogger('scrapy').setLevel(logging.INFO)
logging.getLogger('scrapy.core.engine').setLevel(logging.INFO)
logging.getLogger('scrapy.middleware').setLevel(logging.INFO)
logging.getLogger('scrapy.extensions').setLevel(logging.INFO)
logging.getLogger('scrapy.statscollectors').setLevel(logging.INFO)
logging.getLogger('scrapy.spidermiddlewares').setLevel(logging.INFO)
logging.getLogger('scrapy.downloadermiddlewares').setLevel(logging.INFO)
logging.getLogger('scrapy.pipelines').setLevel(logging.INFO)

# Selenium 로그 레벨 설정
logging.getLogger('selenium').setLevel(logging.INFO)

# urllib3 로그 레벨 설정
logging.getLogger('urllib3').setLevel(logging.WARNING)

if __name__ == "__main__":
    script_start_time = time.time()

    # db 커서 생성
    conn = pymysql.connect(host=setting.host,
                           user=setting.user,
                           password=setting.password,
                           charset='utf8',
                           client_flag=CLIENT.MULTI_STATEMENTS)  # 여러 쿼리문 한번에 가능

    with conn:
        with conn.cursor() as cur:
            # db 없으면 생성
            cur.execute("CREATE DATABASE IF NOT EXISTS `ulife_db`")
            cur.execute("USE ulife_db")
            # 크롤러 실행
            process = CrawlerProcess()
            if test_dicts:
                process.crawl(NoticeSpider, cur=cur, class_dicts=test_dicts)
            else:
                process.crawl(NoticeSpider, cur=cur, class_dicts=class_dicts)
            process.start()

            # # 중복 레코드 수 출력
            # cur.execute(queries.return_query(action='COUNT_DUPL'))
            # duplicate_counts = cur.fetchall()
            # print("Duplicates to be removed:")
            # for major, count in duplicate_counts:
            #     print(f"{major}: {count} duplicates")

            # 중복제거
            cur.execute(queries.return_query(action='REMOVE_DUPL'))
            logging.info('중복제거 완료')

            conn.commit()

    script_end_time = time.time()
    duration = script_end_time - script_start_time
    logging.info(f'duration: {duration}')
