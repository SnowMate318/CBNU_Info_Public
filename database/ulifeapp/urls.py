from django.urls import path
from .views import KeywordWithFCMTokenTestView, MealAPI,  ExtracurAPI, ExtracurAPI_week, ExtracurAPI_month 
from .views import CieatAPI, CieatAPI_week, CieatAPI_month, AnnouncementAPI, AnnouncementAPI_week, AnnouncementAPI_month
from .views import CBNUInfoUserWithSubscribedView, CBNUInfoUserWithSubscribedDetailView, FCMTokenView, FCMTokenDetailView, KeywordFCMTokenAPIView, KeywordWithFCMTokenDetailTestView
from .views import FCMNotificationView, NotificationFCMTokenView
from ulifeapp.admin import ulife_admin_site

urlpatterns = [
    path("announcement/", AnnouncementAPI.as_view()),
    path("announcement/week/", AnnouncementAPI_week.as_view()),
    path("announcement/month/", AnnouncementAPI_month.as_view()),
    path("meal/", MealAPI.as_view()),    
    path("extracur/", ExtracurAPI.as_view()),
    path("extracur/week/", ExtracurAPI_week.as_view()),
    path("extracur/month/", ExtracurAPI_month.as_view()),
    path("cieat/", CieatAPI.as_view()),
    path("cieat/week/", CieatAPI_week.as_view()),
    path("cieat/month/", CieatAPI_month.as_view()),
    path("admin/", ulife_admin_site.urls),

    path('user/', CBNUInfoUserWithSubscribedView.as_view(), name='cbnuinfo-user'),
    path('user/<str:uid>/', CBNUInfoUserWithSubscribedDetailView.as_view()),
    path('user/<str:uid>/subscription/', CBNUInfoUserWithSubscribedDetailView.as_view()),
    path('user/<str:uid>/subscription/<int:subscription_id>/', CBNUInfoUserWithSubscribedDetailView.as_view()),
    
    #path('keyword/',KeywordWithFCMTokenView.as_view()),
    path('notify/', NotificationFCMTokenView.as_view()),
    path('keyword/',KeywordFCMTokenAPIView.as_view()),
    path('test/keyword/',KeywordWithFCMTokenTestView.as_view()),
    path('keyword/<int:keyword_id>/',KeywordWithFCMTokenDetailTestView.as_view()),
    path('fcmtoken/',FCMTokenView.as_view()),
    path('fcmtoken/<int:fcm_token_id>/',FCMTokenDetailView.as_view()),
    path('send-notifications/', FCMNotificationView.as_view())
]