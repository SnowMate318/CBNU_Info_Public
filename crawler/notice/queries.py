TABLE_NAME_MAPPING = {
    '국어국문학과': 'korean',
    '중어중문학과': 'chinese',
    '영어영문학과': 'english',
    '독일언어문화학과': 'german',
    '프랑스언어문화학과': 'french',
    '러시아언어문화학과': 'russian',
    '철학과': 'philosophy',
    '사학과': 'cbnuhistory',
    '고고미술사학과': 'gomisa',
    '사회학과': 'sociology',
    '심리학과': 'psychology',
    '행정학과': 'public',
    '정치외교학과': 'politics',
    '경제학과': 'econ',
    '토목공학부': 'civil',
    '신소재공학과': 'material',
    '기계공학부': 'me',
    '화학공학과': 'cheme',
    '건축공학과': 'cbnuae',
    '안전공학과': 'safety',
    '환경공학과': 'env',
    '공업화학과': 'cbec',
    '도시공학과': 'urban',
    '건축학과': 'cbnuarchi',
    '건축학과2': 'cbnuarchi2',
    '전자공학부': 'elec',
    '전기공학부': 'koamma',
    '정보통신공학부': 'inform',
    '컴퓨터공학과': 'computer',
    '지능로봇공학과': 'airobot',
    '소프트웨어학부': 'software',
    '수학과': 'math',
    '정보통계학과': 'stat',
    '물리학과': 'physics',
    '화학과': 'chem',
    '생물학과': 'biology',
    '미생물학과': 'microbio',
    '생화학과': 'biochem',
    '천문우주학과': 'ast',
    '지구환경과학과': 'geology',
    '경영학부': 'biz',
    '국제경영학과': 'ib',
    '경영정보학과': 'mis',
    '산림학과': 'forestscience',
    '지역건설공학과': 'jigong',
    '바이오시스템공학과': 'bse',
    '목재종이학과': 'woodpaper',
    '식물자원학과': 'crop',
    '환경생명화학과': 'agchem',
    '식품생명공학과': 'food',
    '특용식물학과': 'tobagin',
    '농업경제학과': 'agecon',
    '축산학과': 'animalscience',
    '원예과학과': 'hortisci',
    '식물의학과': 'hortisci',
    '교육학과': 'edu',
    '국어교육과': 'edu_korean',
    '영어교육과': 'edu_english',
    '역사교육과': 'edu_his',
    '지리교육과': 'edu_geo',
    '사회교육과': 'edu_soc',
    '윤리교육과': 'edu_ethics',
    '물리교육과': 'edu_phyedu',
    '화학교육과': 'edu_chemedu',
    '생물교육과': 'edu_bio',
    '지구과학교육과': 'edu_earth',
    '수학교육과': 'edu_mathedu',
    '체육교육과': 'edu_physicaledu',
    '식품영양학과': 'foodn',
    '아동복지학과': 'childwelfare',
    '의류학과': 'fashion',
    '주거환경학과': 'housing',
    '소비자학과': 'consumer',
    '수의학과': 'vetmed',
    '수의예과': 'vetmed2',
    '약학과': 'pharm',
    '의예과': 'medweb',
    '간호학과': 'nursing',
    '자율전공학부': 'fole',
    '조형예술학과': 'fineart',
    '기타': 'notice'  # 기본 테이블 이름 설정
}


def return_query(major='', action=''):
    # table_name = TABLE_NAME_MAPPING.get(major, 'notice')
    table_name = 'notice'  # notice로 통일

    if action == 'CREATE_TABLE':
        CREATE_TABLE_QUERY = f'''
                CREATE TABLE IF NOT EXISTS {table_name}(
                    idx INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
                    major CHAR(15) NOT NULL ,
                    nid CHAR(10) NULL ,
                    title VARCHAR(500) NOT NULL ,
                    url VARCHAR(1000) NOT NULL ,
                    date_post TIMESTAMP
                )'''
        return CREATE_TABLE_QUERY

    if action == 'GET_LATEST_POST':
        GET_LATEEST_POST_QUERY = f'''
                SELECT * FROM {table_name}
                WHERE major='{major}' AND nid!='NOTICE'
                ORDER BY date_post DESC
                LIMIT 1
                '''
        return GET_LATEEST_POST_QUERY

    if action == 'REMOVE_DUPL':
        REMOVE_DUPLE_QUERY = f'''
            DELETE n1
            FROM notice n1
            INNER JOIN (
                SELECT major, title, date_post, MIN(idx) AS min_idx
                FROM notice
                GROUP BY major, title, date_post
                HAVING COUNT(*) > 1
            ) n2 ON n1.major = n2.major AND n1.title = n2.title AND n1.date_post = n2.date_post AND n1.idx > n2.min_idx;
            '''
        return REMOVE_DUPLE_QUERY

    if action == 'COUNT_DUPL':
        count_query = '''
        SELECT major, COUNT(*) - 1 AS duplicate_count
        FROM (
            SELECT major, title, date_post, COUNT(*) AS cnt
            FROM notice
            GROUP BY major, title, date_post
            HAVING COUNT(*) > 1
        ) sub
        GROUP BY major;
        '''
        return count_query