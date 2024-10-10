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

import cieat_query as query

import option
import os
import sys
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
sys.path.append(parent_dir)
from settings import setting
from keyword_notification import keyword_query as keyword

def crawling_cieat():
    # DB 테이블 생성
    cur.execute("DROP TABLE IF EXISTS article_backup")
    
    cur.execute("SELECT 1 FROM information_schema.tables WHERE table_schema = 'ulife_db' AND table_name = 'article'")
    table_exists = cur.fetchone()
    if table_exists:
        # 테이블 이름 변경
        print("백업테이블로 변경")
        cur.execute("RENAME TABLE article TO article_backup")
    else:
        print('기존 테이블 없음')
    
    cur.execute(query.create_article_tb)

    # 디렉토리 존재하면 삭제하고 생성
    script_directory = os.path.dirname(os.path.abspath(__file__))
    directory_path = os.path.join(script_directory, "contentshtmls")
    if os.path.exists(directory_path):
        shutil.rmtree(directory_path)
    os.makedirs(directory_path)

    # 크롬드라이버 세팅
    options = webdriver.ChromeOptions()
    # options.add_argument("headless")
    # options.add_argument("--remote-debugging-port=9222")
    options.add_argument("--disable-application-cache")

    # 인스턴스 세팅
    driver = webdriver.Chrome(options=options)
    wait = WebDriverWait(driver, option.WAITTIME)
    action = ActionChains(driver)

    driver.get('https://cieat.chungbuk.ac.kr/clientMain/a/t/main.do')
    time.sleep(1)

    # 팝업 닫기
    for idx, window in enumerate(driver.window_handles):
        if idx < 1:
            continue
        driver.switch_to.window(window)
        driver.close()

    # 메인창으로 돌아오기
    driver.switch_to.window(driver.window_handles[0])
    wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))

    # 비교과 활동 페이지 진입
    try:
        driver.find_element(By.CSS_SELECTOR,
                            '#container_skip > section.mainprogram_wrap.grid_content > div > div.swiper_btnarea > a').send_keys(Keys.ENTER)
    except:
        wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
        driver.find_element(By.CSS_SELECTOR,
                            '#container_skip > section.mainprogram_wrap.grid_content > div > div.swiper_btnarea > a').send_keys(Keys.ENTER)

    driver.execute_script("window.scrollTo(0,document.body.scrollHeight);")
    driver.execute_script("window.scrollTo(0,0);")
    wait.until(EC.presence_of_all_elements_located(
        (By.CSS_SELECTOR, '#ncrProgramAjaxDiv > article > div.grid_row.program_wrap > div')))
    
    page_num = option.START_PAGE-1
    page_current = ''
    page_start_idx = 0
    art_start_idx = 0
    pageNotCorrect = False
    loop = True
    while loop:
        page_btn_list = driver.find_elements(By.CSS_SELECTOR,
                                             '#ncrProgramAjaxDiv > article > div.paging_place > div > a')

        # 페이지 마다 순회
        for page_idx, page_btn in enumerate(page_btn_list[page_start_idx + 2:-2]):
            page_idx += page_start_idx
            # 페이지 번호 매기기 (html 제목 용)
            page_num += 1
            driver.execute_script("window.scrollTo(0,document.body.scrollHeight);")
            driver.execute_script("window.scrollTo(0,0);")
            
            # 페이지 다를시 스킵
            try:
                if page_num!=int(page_btn.text):
                    page_num-=1
                    continue
            except:
                page_btn = driver.find_element(By.CSS_SELECTOR,
                                                        f'#ncrProgramAjaxDiv > article > div.paging_place > div > a:nth-child({page_idx + 3})')
                if page_num!=int(page_btn.text):
                    page_num-=1
                    continue
                
            #다음페이지 누르고 대기
            while True:
                try:
                    try:
                        page_btn.send_keys(Keys.ENTER)
                    except:
                        page_btn = driver.find_element(By.CSS_SELECTOR,
                                                        f'#ncrProgramAjaxDiv > article > div.paging_place > div > a:nth-child({page_idx + 3})')
                        page_btn.send_keys(Keys.ENTER)
                    break
                except:
                    time.sleep(1)
            wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
                
            arts = ''
            while True: # arts 뜰때까지 대기
                try:
                    wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
                    arts = driver.find_elements(By.XPATH,'//*[@id="ncrProgramAjaxDiv"]/article/div[1]/div')
                    break
                except:
                    time.sleep(1)

            for art_idx, art in enumerate(arts[art_start_idx:]):
                
                art_idx+=art_start_idx
                wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))

                # 페이지 초기화시 탈출
                page_current = driver.find_element(By.CSS_SELECTOR,'#pageIndex').get_attribute('value')
                if int(page_current)!=page_num:
                    print('페이지 초기화. 재조정')
                    pageNotCorrect = True
                    page_start_idx = page_idx
                    art_start_idx = art_idx
                    break 
                
                while True:
                    try:
                        tmp = art.find_element(By.CSS_SELECTOR,'div > p.previewimg_box > a')
                        state = art.find_element(By.CSS_SELECTOR, 'div.program_lisbox > div > p > span').text
                        break
                    except:
                        art = driver.find_element(By.CSS_SELECTOR,
                                                      f'#ncrProgramAjaxDiv > article > div.grid_row.program_wrap > div:nth-child({art_idx + 1})')

                tmp1 = tmp.get_attribute('onclick')
                pattern = r"NCR\d+"
                matches = re.findall(pattern, tmp1)
                extracted_pattern = matches[0]
                url = f'https://cieat.chungbuk.ac.kr/ncrProgramAppl/a/m/getProgramDetail.do?npiKeyId={extracted_pattern}'
                response = requests.get(url)

                # 페이지 소스 받기
                html = response.text
                soup = bs(html, 'html.parser')

                # 페이지 파싱
                # state
                title = soup.select_one('#container_skip > section.program_content > dl > dt > p').get_text(strip=True)
                art_organization = soup.select_one(
                    '#container_skip > section.program_content > dl > dt > span').get_text(strip=True)
                recruit_time = soup.select_one('#container_skip > section.program_content > dl > dd:nth-child(2)')
                recruit_time_start = ''
                recruit_time_close = ''
                part_class = soup.select_one('#container_skip > section.program_content > dl > dd:nth-child(4)')
                part_grade = soup.select_one('#container_skip > section.program_content > dl > dd:nth-child(5)')
                category = soup.select_one('#container_skip > section.program_content > dl > dd:nth-child(8)')
                score = soup.select_one(
                    '#container_skip > section.program_content > dl > dd:nth-child(9) > span > span').get_text(
                    strip=True)
                point = soup.select_one('div.mileagepoint_box > p > span').get_text(strip=True)
                htmlpath = ''

                # # 본문 html 저장
                # head = soup.select_one('head')
                # body = soup.select_one('#container_skip')
                # body.select_one('#container_skip > section > div.progrmaapply_box > ul').decompose()  # 접수 삭제
                # body.select_one('#container_skip > div.grid_content.page_footer').decompose()  # 목록보기 삭제
                # content_html = f"<html>{str(head)}{str(body)}</html>"
                # htmlname = f'{page_num}_{art_idx + 1}.html'
                # htmlpath = os.path.join(directory_path, htmlname)

                # with open(htmlpath, 'w', encoding="utf-8") as file:
                #     file.write(content_html)

                # 전처리
                # 문자열 빼기
                recruit_time.select_one('strong').decompose()
                recruit_time = recruit_time.get_text(strip=True)
                part_class.select_one('strong').decompose()
                part_class = part_class.get_text(strip=True)
                part_grade.select_one('strong').decompose()
                part_grade = part_grade.get_text(strip=True)
                category.select_one('strong').decompose()
                category = category.get_text(strip=True)
                score = float(re.findall(r'\d+\.\d+|\d+', score)[0])  # 소수점만 추출
                point = int(point[:-1])

                # 시간 문자열에서 앞의 시간과 뒤의 시간을 분리
                recruit_time_start, recruit_time_close = recruit_time.split(" ~ ")
                # 날짜와 시간 형식 지정
                date_format = "%Y-%m-%d %H시"
                # 문자열을 datetime 형식으로 변환
                recruit_time_start = datetime.strptime(recruit_time_start, date_format)
                try:
                    recruit_time_close = datetime.strptime(recruit_time_close, date_format)
                except Exception as e:  # 24시로 표현될 경우
                    recruit_time_close = recruit_time_close[:-3] + '00시'
                    recruit_time_close = datetime.strptime(recruit_time_close, date_format) + timedelta(days=1)

                # 중복 체크


                # DB에 추가
                                    
                val = ('씨앗', title, url)
                cur.execute(keyword.insert_keyword, val)
                    
                print(f"키워드 db 추가완료: host: 씨앗, title: {title}, url: {url}")    
                    
                val = (title, state, art_organization, recruit_time, recruit_time_start, recruit_time_close, part_class,
                       part_grade, category, score, point, htmlpath,url)
                cur.execute(query.insert_article, val)
                print(f"DB 추가 완료. page : {page_num}, idx : {art_idx}, title : {title}")
                

            else:
                art_start_idx = 0
                # 게시물 개수 부족하면 반복종료
                arts = driver.find_elements(By.XPATH,'//*[@id="ncrProgramAjaxDiv"]/article/div[1]/div')
                if len(arts) != 8:
                    loop = False
                
            if pageNotCorrect:
                break
            
            
        
        else: # 페이지 반복문 온전히 끝난경우
            page_start_idx = 0
            arts = driver.find_elements(By.XPATH,'//*[@id="ncrProgramAjaxDiv"]/article/div[1]/div')
            
            # 마지막 페이지와 현재페이지가 일치하는경우 반복종료
            page_btn_list = driver.find_elements(By.CSS_SELECTOR,
                                             '#ncrProgramAjaxDiv > article > div.paging_place > div > a')
            last_page_btn = page_btn_list[-1]
            last_page_onclick_string = last_page_btn.get_attribute('onclick')
            pattern = r"\d+"
            matches = re.findall(pattern, last_page_onclick_string)
            last_page = matches[0]
            if int(last_page) == int(page_current):
                loop = False
                pageNotCorrect = False
            
            # 페이지 개수 부족하면 반복 종료
            elif len(page_btn_list) != 9:
                loop = False
                pageNotCorrect = False
            # 게시물 개수 부족하면 반복종료
            
            elif len(arts) != 8:
                loop = False
                pageNotCorrect = False
            
            else: # 다음페이지 클릭          
                try:
                    page_btn_list[-2].send_keys(Keys.ENTER)
                except:
                    wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
                    page_btn_list = driver.find_elements(By.CSS_SELECTOR,
                                                        '#ncrProgramAjaxDiv > article > div.paging_place > div > a')
                    page_btn_list[-2].send_keys(Keys.ENTER)

                wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))

        error_cnt=0
        while pageNotCorrect:
            error_cnt+=1
            if error_cnt > 20:
                raise Exception('페이지 이동 에러 발생')
            try:
                page_current = driver.find_element(By.CSS_SELECTOR,'#pageIndex').get_attribute('value')
                if int(page_current)!=page_num:
                    wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
                    page_tmp_list = driver.find_elements(By.CSS_SELECTOR,
                                                            '#ncrProgramAjaxDiv > article > div.paging_place > div > a')
                    pageFind = False
                    for page_tmp in page_tmp_list[2:-2]:
                        if int(page_tmp.text)==page_num:
                            page_tmp.send_keys(Keys.ENTER)
                            wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
                            pageFind = True
                            break
                    if not pageFind:
                        try:
                            page_tmp_list[-2].send_keys(Keys.ENTER)
                        except:
                            pass
                        wait.until(lambda driver:driver.execute_script("return jQuery.active==0"))
                else:
                    pageNotCorrect = False
                    page_num -=1
            except:
                pass


    driver.close()


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
        while fail<3:
            with conn.cursor() as cur:
                try:
                    starttime = time.time()
                    # db 있으면 버리고 생성
                    cur.execute("CREATE DATABASE IF NOT EXISTS `ulife_db`")
                    cur.execute("USE ulife_db")

                    # 크롤링 코드 동작
                    crawling_cieat()

                    # db 저장
                    conn.commit()
                    succ+=1
                    print('씨앗 SUCCESS')
                    break
                except Exception as e:
                    print(f'Fail. ERROR : {e}')
                    fail+=1
                    
                    cur.execute("SELECT 1 FROM information_schema.tables WHERE table_schema = 'ulife_db' AND table_name = 'article_backup'")
                    table_exists = cur.fetchone()
                    if table_exists:
                        # 테이블 이름 변경
                        cur.execute("DROP TABLE IF EXISTS article")
                        cur.execute("RENAME TABLE article_backup TO article")
                        print("크롤링 실패, 백업테이블 기존테이블로 가져오기")
                    
                    
                finally:
                    print(f"total : {succ+fail}, success : {succ}, fail : {fail} . time : {time.time()-starttime}")
                
        if fail == 3:
            print('씨앗 크롤링 실패')    
        