table_name = 'keyword_notification'
            
insert_keyword = f'''
    INSERT INTO {table_name} (host,title,url) VALUES (%s,%s,%s)
''' 