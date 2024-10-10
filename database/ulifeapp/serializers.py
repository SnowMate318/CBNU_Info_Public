from rest_framework import serializers
from .models import Meal, Cieat, Extracur, Announcement, CBNUInfoUser, Subscription, Keyword, FCMToken
from .models import KeywordNotification
class MealSerializer(serializers.ModelSerializer):
    class Meta:
        model = Meal
        fields = ['menu_date','food_time','cafeteria_name','food_name','food_idx']
        
class CieatSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cieat
        fields = ['article_idx','title','state','art_organization','recruit_time','recruit_time_start','recruit_time_close','part_class','part_grade','category','score','point','htmlpath', 'url']
        
class ExtracurSerializer(serializers.ModelSerializer):
    class Meta:
        model = Extracur
        fields = ['post_id','category','category_sub','url','title','post_organization','startdate','closingdate','apply_url','img_url','img_filepath','img_thumbnail_url','img_thumbnail_filepath']

class AnnouncementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Announcement
        fields = ['idx','major','nid','title','url','date_post']
        


class SubscribedOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = Subscription
        fields = ['id','name']
        
class CBNUInfoUserSerializer(serializers.ModelSerializer):
    
    class Meta:
            model = CBNUInfoUser
            fields = ['uid','udid','fcm_token','renew_datetime','type']

        
class UserWithSubscribedSerializer(serializers.ModelSerializer):
    subscribeds = SubscribedOnlySerializer(many=True, read_only=True)
    
    class Meta:
            model = CBNUInfoUser
            fields = ['uid','udid','fcm_token','renew_datetime','type','subscribeds']

class FCMTokenOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = FCMToken
        fields = ['keyword','fcm_token']
        
class KeywordWithFCMTokenSerializer(serializers.ModelSerializer):
    
    fcm_tokens = FCMTokenOnlySerializer(many=True)
    class Meta:
        model = Keyword
        fields = ['id','host','name','fcm_tokens']      
        
        
        
class KeywordOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = Keyword
        fields = ['host','name']        

        
class KeywordNotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = KeywordNotification
        fields = ['host', 'title', 'url']

