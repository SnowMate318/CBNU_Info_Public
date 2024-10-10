import scrapy

class MenuItem(scrapy.Item):

    menu_date = scrapy.Field() # 메뉴 날짜
    # weekday = scrapy.Field() # 메뉴 요일
    food_time = scrapy.Field() # 아침,점심,저녁
    cafeteria_name = scrapy.Field()  # 식당 이름
    food_name = scrapy.Field() # 음식 이름
