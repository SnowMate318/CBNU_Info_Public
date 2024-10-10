'''
1. 날짜 date
2. 먹는 시간대 char(10)
3. 식당 이름 char(5)
4. 메뉴 char (30)
5. 인덱스 int
'''

create_menu_tb = '''
CREATE TABLE IF NOT EXISTS food(
    menu_date DATE,
    food_time CHAR(10) NOT NULL ,
    cafeteria_name CHAR(5) NOT NULL ,
    food_name CHAR(100) NOT NULL ,
    food_idx INT NOT NULL PRIMARY KEY AUTO_INCREMENT
)'''    

romove_dupl = '''
    DELETE n1
    FROM food n1
    INNER JOIN (
        SELECT menu_date, food_name, cafeteria_name,food_time, MIN(food_idx) AS min_idx
        FROM food
        GROUP BY menu_date, food_name, cafeteria_name,food_time
        HAVING COUNT(*) > 1
    ) n2 ON n1.menu_date = n2.menu_date AND n1.food_name = n2.food_name AND n1.cafeteria_name = n2.cafeteria_name AND n1.food_time = n2.food_time AND n1.food_idx > n2.min_idx;
'''