table_name = 'post'
create_post_tb = f'''
            CREATE TABLE IF NOT EXISTS {table_name}(
                category char(15) NOT NULL ,
                category_sub char(30) NOT NULL,
                url varchar(1000) NOT NULL,
                post_id INT NOT NULL PRIMARY KEY,
                title varchar(500) NOT NULL ,
                post_organization varchar(200) NOT NULL,
                startdate DATE NOT NULL,
                closingdate TIMESTAMP,
                apply_url varchar(1000) NOT NULL,
                hits INT NOT NULL ,
                img_url VARCHAR(1000) NOT NULL,
                img_filepath VARCHAR(1000) NOT NULL,
                img_thumbnail_url VARCHAR(1000) NOT NULL,
                img_thumbnail_filepath VARCHAR(1000) NOT NULL   
            )
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
            '''
insert_post = f'''
    INSERT INTO {table_name} VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
'''
