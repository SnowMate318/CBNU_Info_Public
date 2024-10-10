import re
from datetime import datetime

date_patterns = {
    '%Y-%m-%d %H:%M:%S': r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}',
    '%Y-%m-%d': r'\d{4}-\d{2}-\d{2}',
    '%Y.%m.%d %H:%M': r'\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}',
    '%y-%m-%d %H:%M': r'\d{2}-\d{2}-\d{2} \d{2}:\d{2}',
    '%Y-%m-%d %H:%M': r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}',
    '%Y/%m/%d': r'\d{4}/\d{2}/\d{2}',
    '%Y.%m.%d': r'\d{4}\.\d{2}\.\d{2}',
    # '%m-%d': r'\d{2}-\d{2}',
    # '%m.%d': r'\d{2}\.\d{2}'
}


def parse_date(date_post, last_date_post=None):
    def extract_date(raw_date):
        """
        날짜 문자열에 트래쉬 데이터 섞인경우 날짜만 추출하는 함수
        """
        for date_format, pattern in date_patterns.items():
            match = re.search(pattern, raw_date)
            if match:
                return match.group()
        return raw_date  # 매치 안되면 원본문자열

    date_str = extract_date(date_post)

    for fmt in date_patterns.keys():
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue

    # 월-일만 나온 경우
    try:
        current_year = datetime.now().year
        date_post_strp = datetime.strptime(f"{current_year}-{date_str}", '%Y-%m-%d')
        today = datetime.today()

        if last_date_post:
            last_date = datetime.strptime(last_date_post, '%Y-%m-%d %H:%M:%S')
            while date_post_strp > last_date:
                current_year -= 1
                date_post_strp = datetime.strptime(f"{current_year}-{date_str}", '%Y-%m-%d')
        else:
            if date_post_strp > today:
                date_post_strp = date_post_strp.replace(year=current_year - 1)

        return date_post_strp
    except ValueError:
        pass

    # 시:분만 나온 경우
    try:
        current_day = datetime.now().date()
        return datetime.strptime(f"{current_day} {date_str}", '%Y-%m-%d %H:%M')
    except ValueError:
        pass

    # 시.분만 나온 경우
    try:
        current_day = datetime.now().date()
        return datetime.strptime(f"{current_day} {date_str}", '%Y-%m-%d %H.%M')
    except ValueError as e:
        print(f"날짜 오류 : {date_str},  {e}")
        return date_str


def parse_title(title):
    title = re.sub(r'[`\"\'\n\t\r]', '', title)
    title = re.sub(r'\s+', ' ', title)
    return title


def filter_valid_texts(getall_list):
    """
    주어진 텍스트 리스트에서 유효한 텍스트만 반환하는 함수.
    """
    for text in getall_list:
        if text.strip():
            return text.strip()

