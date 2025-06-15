# 충북대학교 - 종합정보 서비스
<img src="https://github.com/user-attachments/assets/e732981a-a94c-4188-a1e6-2946a4207c83" width="500" height="250"/>

## 개요

---

학내 여러 사이트를 통해 얻을 수 있는 정보를 한 눈에 조회 가능한 서비스

### 기능

- 학내 학과 공지사항, 기숙사, 식단 정보를 저장하여 관리합니다.
- 사용자가 조회를 원하는 정보를 선택할 수 있습니다.
- 키워드 알림 기능을 통해 사용자가 원하는 정보를 알림으로 받을 수 있습니다.

## 결과물

---

### 주요 화면

<img src="https://github.com/user-attachments/assets/ae41a016-6827-4205-82b2-1bdbf13b5775" width="250" height="500"/>

<img src="https://github.com/user-attachments/assets/6ada9e0e-a761-432a-9cc1-ac8e9476b0ac" width="250" height="500"/>

<img src="https://github.com/user-attachments/assets/17a05fa1-982e-4c1f-b877-0c29c1e6d3ca" width="250" height="500"/>

<img src="https://github.com/user-attachments/assets/2093d998-f34d-45b4-9ecf-2c8814c7dc67" width="250" height="500"/>

## 아키텍쳐

---

![Image](https://github.com/user-attachments/assets/f651c23f-4b32-4cde-bdb2-41872c216a0b)

- 어플리케이션
    - 사용자가 입력한 정보를 바탕으로 정보 조회
- 서버
    - 어플리케이션에 필요한 정보를 제공
- 데이터베이스
    - 서비스에 필요한 학내 정보들을 저장
- 크롤러
    - 데이터베이스에 학내 정보를 지속적으로 추가해줌

## 개발 정보

---

### 개발 기간

- 2023.05 ~ 2024.05

### 개발 인원

- 2명

### 핵심 기능

- 학내 정보 크롤링 기능
- 저장된 학내 정보 조회 기능
- 키워드 알림 기능

### 지원자 개인 기여

- 앱 제작
    - 홈 화면 구현
    - 상세 보기 화면 구현
    - 구독정보 설정화면 구현
    - API 연결
    - 상태관리 기능 구현

- 앱 배포
    - 구글 플레이스토어 출시
    - 앱스토어 출시
      
- 서버 제작
    - 데이터베이스 설계 및 구축
    - 크롤링 결과를 기반으로 사용자에게 알림 전송
      
- 서버 배포

### 사용 기술

- 앱
    - Dart
    - Flutter
- 서버
    - Python
    - Django
    - DjangoRestFramework
- 배포
    - Linux 20.04
    - nginx
    - gunicorn
- DB
    - MySQL
- 크롤러
    - scrapy
    - selenium
