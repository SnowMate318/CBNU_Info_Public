// ignore_for_file: constant_identifier_names
//size
const double PAGE_PADDING_SIZE = 16.0;
const double BORDER_CIRCULAR = 5.0;
const double TABBAR_HEIGHT = 56.0;
const int MAX_DB_READ_LIMIT = 30;

const List<String> ACTIVITIES = [
  '전체',
  ACTIVITY_IN_CAMPUS,
  ACTIVITY_OUT_CAMPUS,
  ACTIVITY_TODAY_MENU,
];
const String ACTIVITY_IN_CAMPUS = '교내 활동';
const String ACTIVITY_OUT_CAMPUS = '교외 활동';
const String ACTIVITY_TODAY_MENU = '오늘의 메뉴';

const List<String> VIEW_OPTIONS = [
  VIEW_OPTION_DEPARTMENT,
  VIEW_OPTION_DORMITORY,
  VIEW_OPTION_DURATION,
];
const String VIEW_OPTION_DEPARTMENT = '소속 학과/학부';
const String VIEW_OPTION_DORMITORY = '기숙사';
const String VIEW_OPTION_DURATION = '글 보기';

const List<String> DURATIONS = [
  '전체',
  DURATION_WEEK,
  DURATION_MONTH,
];
const String DURATION_MONTH = '최근 1달';
const String DURATION_WEEK = '최근 1주일';

const List<String> FOOD_TIMES = [
  FOOD_BREAKFIRST,
  FOOD_BLUNCH,
  FOOD_LUNCH,
  FOOD_DINNER
];
const String FOOD_BREAKFIRST = '아침';
const String FOOD_BLUNCH = '아점';
const String FOOD_LUNCH = '점심';
const String FOOD_DINNER = '저녁';

const List<String> CAFETERIAS = [
  CAFETERIA_HANBIT,
  CAFETERIA_BYEOLBIT,
  CAFETERIA_UNHASU,
  DORM_YANGJINJAE,
  DORM_YANGSEONGJAE,
  DORM_GAESEONGJAE,
];
const String CAFETERIA_HANBIT = '한빛식당';
const String CAFETERIA_BYEOLBIT = '별빛식당';
const String CAFETERIA_UNHASU = '은하수식당';

const String DORM_YANGJINJAE = '양진재';
const String DORM_YANGSEONGJAE = '양성재';
const String DORM_GAESEONGJAE = '본관';

Map<String, List<String>> departmentMap = {
  "없음": [],
  "인문대학": [
    "인문대학",
    "국어국문학과",
    "중어중문학과",
    "영어영문학과",
    "독일언어문학학과",
    "프랑스언어문학학과",
    "러시아언어문화학과",
    "철학과",
    "사학과",
    "고고미술사학과"
  ],
  "사회과학대학": ["사회과학대학", "사회학과", "심리학과", "행정학과", "정치외교학과", "경제학과"],
  "자연과학대학": [
    "자연과학대학",
    "수학과",
    "정보통계학과",
    "물리학과",
    "화학과",
    "생물학과",
    "미생물학과",
    "생화학과",
    "천문우주학과_학과", "천문우주학과_학부",
    "지구환경과학과",

  ],
  "경영대학": ["경영대학", "경영학부", "국제경영학과", "경영정보학과"],
  "전자정보대학": [
    "전자정보대학",
    "전기공학부",
    "전자공학부",
    "정보통신공학부",
    "컴퓨터공학과",
    "소프트웨어학부",
    "지능로봇공학과"
  ],
  "농업생명환경대학": [
    "농업생명환경대학",
    "산림학과",
    "지역건설공학과",
    "바이오시스템공학과",
    "목재종이과학과",
    "농업경제학과",
    "식물자원학과",
    "환경생명화학과",
    "축산학과",
    "식품생명공학과",
    "특용식물학과",
    "원예과학과"
  ],
  "사범대학": [
    "사범대학",
    "교육학과",
    "국어교육과",
    "영어교육과",
    "역사교육과",
    "지리교육과",
    "사회교육과",
    "윤리교육과",
    "물리교육과",
    "화학교육과",
    "생물교육과",
    "지구과학교육과",
    "수학교육과",
    "체육교육과",
  ],
  "생활과학대학": [
    "생활과학대학",
    "식품영양학과",
    "아동복지학과",
    "의류학과(패션디자인정보학과)",
    "주거환경학과",
    "소비자학과",
    "프랑스언어문학학과",
    "러시아언어문화학과",
    "철학과",
    "사학과",
    "고고미술사학과"
  ],
  "공과대학": [
    "공과대학",
    "토목공학부",
    "화학공학과",
    "기계공학부",
    "신소재공학과",
    "건축공학과",
    "안전공학과",
    "환경공학과",
    "공업화학과",
    "도시공학과",
    "건축학과_뉴스",
    "건축학과_공모전"
  ],
  "수의과대학": ["수의예과", "수의학과"],
  "약학대학": ["약학과", "제약학과"],
  "의과대학": [
    "의예과",
    "의학과",
    "간호학과",
  ],
  "바이오헬스공유대학": [],
  "자율전공학부": ["자율전공학부"],
  "융합학과군(조형예술학과/디자인학과)": ["조형예술학과", "디자인학과"],
};