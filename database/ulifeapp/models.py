from django.db import models
from django.db.models import UniqueConstraint

class Meal(models.Model):
    menu_date = models.DateField(blank=True, null=True)
    food_time = models.CharField(max_length=10)
    cafeteria_name = models.CharField(max_length=5)
    food_name = models.CharField(max_length=100)
    food_idx = models.AutoField(primary_key=True)

    class Meta:
        managed = False
        app_label = 'ulifeapp'
        db_table = 'food'
        
class Cieat(models.Model):
    article_idx = models.IntegerField(primary_key=True)
    title = models.CharField(max_length=500)
    state = models.CharField(max_length=20)
    url = models.CharField(max_length=1000)
    art_organization = models.CharField(max_length=200, null=True)
    recruit_time = models.CharField(max_length=50)
    recruit_time_start = models.DateTimeField(blank=True, null=True)
    recruit_time_close = models.DateTimeField(blank=True, null=True)
    part_class = models.CharField(max_length=1000)
    part_grade = models.CharField(max_length=20)
    category = models.CharField(max_length=500)
    score = models.FloatField()
    point = models.IntegerField()
    htmlpath = models.CharField(max_length=1000)
    
    class Meta:
        managed = False
        app_label = 'ulifeapp'
        db_table = 'article'
        
class Extracur(models.Model):
    category = models.CharField(max_length = 15)
    category_sub = models.CharField(max_length = 30)
    url = models.CharField(max_length=1000)
    post_id = models.IntegerField(primary_key=True)
    title = models.CharField(max_length=500)
    post_organization = models.CharField(max_length=200)
    startdate = models.DateField(blank=True)
    closingdate = models.DateTimeField(blank=True, null=True)
    apply_url = models.CharField(max_length=1000)
    hits = models.IntegerField()
    img_url = models.CharField(max_length=1000)
    img_filepath = models.CharField(max_length=1000)
    img_thumbnail_url = models.CharField(max_length=1000)
    img_thumbnail_filepath = models.CharField(max_length=1000)
    
    class Meta:
        managed = False
        app_label = 'ulifeapp'
        db_table = 'post'

class Announcement(models.Model):
    idx = models.IntegerField(primary_key=True)
    major = models.CharField(max_length=15)
    nid = models.CharField(max_length=10)
    title = models.CharField(max_length=500)
    url = models.CharField(max_length=1000)
    date_post = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'notice'


class CBNUInfoUser(models.Model):
    uid = models.CharField(max_length=128, primary_key=True)   
    udid = models.CharField(max_length=128, blank=True, null=True)     
    fcm_token = models.CharField(max_length=500, blank=True, null=True)
    renew_datetime = models.DateTimeField(auto_now=True)
    type = models.CharField(max_length = 20, null = True, blank = True)
    
    class Meta:
        db_table = 'cbnuinfo_user'
            
            
class Subscription(models.Model):
    cbnu_info_user  = models.ForeignKey(CBNUInfoUser, related_name = 'subscription', on_delete = models.CASCADE, to_field='uid')
    name = models.CharField(max_length=40)
    
    class Meta:
        db_table = "subscription"

    
class Keyword(models.Model):
    name = models.CharField(max_length=30)
    host = models.CharField(max_length=40)
    
    class Meta:
        db_table = "keyword"
        constraints = [
            UniqueConstraint(fields=['name', 'host'], name='unique_name_host')
        ]
    
class FCMToken(models.Model):
    keyword = models.ForeignKey(Keyword, related_name='fcm_tokens', on_delete=models.CASCADE)
    fcm_token = models.CharField(max_length=1000)
    on_alarm = models.BooleanField(default=True)
    class Meta:
        db_table = "fcm_token"
        
class KeywordNotification(models.Model):
    host = models.CharField(max_length=100)
    title = models.CharField(max_length=500)
    url = models.CharField(max_length=1000)
    
    class Meta:
        db_table = "keyword_notification"
        managed = True