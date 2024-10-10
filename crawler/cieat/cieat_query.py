table_name = 'article'
create_article_tb = f'''
            CREATE TABLE IF NOT EXISTS {table_name}(
                article_idx INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
                title VARCHAR(500) NOT NULL ,
                state CHAR(20) NOT NULL ,
                art_organization VARCHAR(200),
                recruit_time CHAR(50) NOT NULL ,
                recruit_time_start DATETIME ,
                recruit_time_close DATETIME ,
                part_class VARCHAR(1000) NOT NULL ,
                part_grade CHAR(20) NOT NULL ,
                category VARCHAR(100) NOT NULL ,
                score FLOAT ,
                point INT,
                htmlpath VARCHAR(1000) NULL,
                url VARCHAR(1000) NOT NULL
            )
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
            '''
            
insert_article = f'''
    INSERT INTO {table_name} (title, state, art_organization, recruit_time, recruit_time_start, recruit_time_close, part_class,
                       part_grade, category, score, point, htmlpath,url)  VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
'''