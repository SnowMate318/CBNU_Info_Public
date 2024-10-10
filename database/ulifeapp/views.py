from django.shortcuts import get_object_or_404
from rest_framework.generics import ListAPIView
from rest_framework.views import APIView
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.permissions import IsAuthenticated, AllowAny
from .authentication import FirebaseAuthentication
from ulifeapp import authentication
#from ulifeapp.push_fcm_notification import send_to_firebase_cloud_messaging
from.models import Meal, Extracur, Cieat, Announcement, CBNUInfoUser, Subscription, Keyword, FCMToken
from rest_framework.pagination import PageNumberPagination
from.serializers import MealSerializer, CieatSerializer, ExtracurSerializer, AnnouncementSerializer, UserWithSubscribedSerializer, SubscribedOnlySerializer,FCMTokenOnlySerializer,KeywordWithFCMTokenSerializer
from rest_framework import status
from rest_framework.response import Response
#from rest_framework_api_key.models import APIKey
from django.utils import timezone
from datetime import timedelta
from django.http import Http404, JsonResponse
from django.views import View

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import KeywordNotification, Keyword, FCMToken
from .serializers import KeywordNotificationSerializer, FCMTokenOnlySerializer
from .push_fcm import send_to_firebase_cloud_messaging  # send_to_firebase_cloud_messaging 함수를 포함하는 파일을 임포트합니다.

class FCMNotificationView(APIView):
    def get(self, request, *args, **kwargs):
        keyword_notifications = KeywordNotification.objects.all()
        serializer = KeywordNotificationSerializer(keyword_notifications, many=True)

        for map in serializer.data:
            host = map['host']
            title = map['title']
            url = map['url']
            
            tokenList = title.split()
            for token in tokenList:
                keywords = Keyword.objects.filter(host=host, name__contains=token)
                for keyword in keywords:
                    fcmTokens = FCMToken.objects.filter(keyword=keyword)
                    fcmtokenSerializer = FCMTokenOnlySerializer(fcmTokens, many=True)
                    
                    for fcmToken in fcmtokenSerializer.data:
                        actualToken = fcmToken['fcm_token']
                        send_to_firebase_cloud_messaging(host, title, actualToken, url)  # fcmToken['token']을 적절히 수정해야 할 수 있습니다.
        
        return Response({"message": "FCM Notifications sent successfully"}, status=status.HTTP_200_OK)
    
    def post(self, request, *args, **kwargs):

        serializer = KeywordNotificationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # 새로운 사용자 생성 또는 업데이트
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
# from .tasks import send_notification
# from firebase_admin.messaging import Message, Notification, send

class StudentPaginationAnn(PageNumberPagination):
    #first_page_size = 8
    page_size = 30

class StudentPaginationCieat(PageNumberPagination):
    #first_page_size = 4
    page_size = 30

class StudentPaginationAnnExt(PageNumberPagination):
    #first_page_size = 4
    page_size = 30

class AnnouncementAPI(ListAPIView):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer
    pagination_class = StudentPaginationAnn
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['=major']# title
    ordering_fields = ['date_post']
    ordering= ['-date_post']
            
class AnnouncementAPI_week(ListAPIView):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer
    pagination_class = StudentPaginationAnn
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['=major']# title
    ordering_fields = ['date_post']
    ordering= ['-date_post']
    
    def get_queryset(self):
        # Calculate the date range for the last week
        end_date = timezone.now()
        start_date = end_date - timedelta(days=7)

        # Filter the queryset to get data within the date range
        queryset = Announcement.objects.filter(date_post__gte=start_date, date_post__lte=end_date)
        return queryset

class AnnouncementAPI_month(ListAPIView):
    queryset = Announcement.objects.all()
    serializer_class = AnnouncementSerializer
    pagination_class = StudentPaginationAnn
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['=major']# title
    ordering_fields = ['date_post']
    ordering= ['-date_post']
    
    def get_queryset(self):
        # Calculate the date range for the last week
        end_date = timezone.now()
        def month_days(month):
            if month == 1 or 3 or 5 or 7 or 8 or 10 or 12:
                return 30
            else:
                return 31
        start_date = end_date - timedelta(days=month_days(end_date.month))

        # Filter the queryset to get data within the date range
        queryset = Announcement.objects.filter(date_post__gte=start_date, date_post__lte=end_date)
        return queryset

class MealAPI(ListAPIView):
    serializer_class = MealSerializer
    filter_backends = [SearchFilter]
    search_fields = ['=menu_date', '=cafeteria_name', '=food_time']
    filterset_fields = ['=menu_date', '=cafeteria_name', '=food_time']
    queryset = Meal.objects.all()    
    
    
class CieatAPI(ListAPIView):
    queryset = Cieat.objects.all()
    serializer_class = CieatSerializer
    pagination_class = StudentPaginationCieat
    filter_backends = [SearchFilter]
    search_fields = ['title', 'category']
    ordering_fields = ['recruit_time_start']
    ordering= ['-recruit_time_start']
    
class CieatAPI_week(ListAPIView):
    
    serializer_class = CieatSerializer
    pagination_class = StudentPaginationCieat
    filter_backends = [SearchFilter]
    search_fields = ['title', 'category']
    ordering_fields = ['recruit_time_start']
    ordering= ['-recruit_time_start']
    
    def get_queryset(self):
        # Calculate the date range for the last week
        end_date = timezone.now()
        start_date = end_date - timedelta(days=7)

        # Filter the queryset to get data within the date range
        queryset = Cieat.objects.filter(recruit_time_start__gte=start_date, recruit_time_start__lte=end_date)
        return queryset
    
class CieatAPI_month(ListAPIView):
    
    serializer_class = CieatSerializer
    pagination_class = StudentPaginationCieat
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['title', 'category']
    ordering_fields = ['recruit_time_start']
    ordering= ['-recruit_time_start']    
    
    def get_queryset(self):
        # Calculate the date range for the last week
        end_date = timezone.now()
        def month_days(month):
            if month == 1 or 3 or 5 or 7 or 8 or 10 or 12:
                return 30
            else:
                return 31
        start_date = end_date - timedelta(days=month_days(end_date.month))

        # Filter the queryset to get data within the date range
        queryset = Cieat.objects.filter(recruit_time_start__gte=start_date, recruit_time_start__lte=end_date)
        return queryset

    
class ExtracurAPI(ListAPIView):
    queryset = Extracur.objects.all()
    serializer_class = ExtracurSerializer
    pagination_class = StudentPaginationAnnExt
    filter_backends = [SearchFilter, OrderingFilter]
    search_fields = ['=category','=category_sub']
    ordering_fields = ['startdate']
    ordering= ['-startdate']
    
class ExtracurAPI_week(ListAPIView):
    queryset = Extracur.objects.all()
    serializer_class = ExtracurSerializer
    pagination_class = StudentPaginationAnnExt
    filter_backends = [SearchFilter, OrderingFilter]  
    search_fields = ['=category','=category_sub']
    ordering_fields = ['startdate']
    ordering= ['-startdate']
    
    def get_queryset(self):
        # Calculate the date range for the last week
        end_date = timezone.now()
        start_date = end_date - timedelta(days=7)

        # Filter the queryset to get data within the date range
        queryset = Extracur.objects.filter(startdate__gte=start_date, startdate__lte=end_date)
        return queryset
    
class ExtracurAPI_month(ListAPIView):
    queryset = Extracur.objects.all()
    serializer_class = ExtracurSerializer
    pagination_class = StudentPaginationAnnExt
    filter_backends = [SearchFilter, OrderingFilter]   
    search_fields = ['=category','=category_sub']
    ordering_fields = ['startdate']
    ordering= ['-startdate']
    
    def get_queryset(self):
        # Calculate the date range for the last week
        end_date = timezone.now()
        def month_days(month):
            if month == 1 or 3 or 5 or 7 or 8 or 10 or 12:
                return 30
            else:
                return 31
        start_date = end_date - timedelta(days=month_days(end_date.month))

        # Filter the queryset to get data within the date range
        queryset = Extracur.objects.filter(startdate__gte=start_date, startdate__lte=end_date)
        return queryset



class CBNUInfoUserWithSubscribedView(APIView):
    authentication_classes = []
    permission_classes = [AllowAny]
    def get(self, request, format=None):
        users = CBNUInfoUser.objects.all() 
        serializer = UserWithSubscribedSerializer(users, many=True) 
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def post(self, request, *args, **kwargs):

        serializer = UserWithSubscribedSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # 새로운 사용자 생성 또는 업데이트
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
    
    
    
class CBNUInfoUserWithSubscribedDetailView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, uid):
        user = get_object_or_404(CBNUInfoUser, uid=uid)
        serializer = UserWithSubscribedSerializer(user) 
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def patch(self, request, uid, format=None):
        user = get_object_or_404(CBNUInfoUser, uid=uid)
        serializer = UserWithSubscribedSerializer(user, data=request.data, partial=True)  # 부분 업데이트
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request, uid):
        # URL에서 uid를 추출
        user = get_object_or_404(CBNUInfoUser, uid=uid)
        user.delete()
        
        return Response({"message": "로그아웃이 완료되었습니다"}, status=204)
       


class KeywordWithFCMTokenTestView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, format=None):
        keywords = Keyword.objects.all() 
        serializer = KeywordWithFCMTokenSerializer(keywords, many=True) 
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class KeywordWithFCMTokenDetailTestView(APIView):
    permission_classes = [AllowAny]
    authentication_classes = []

    def get(self, request, keyword_id):
        keywords = get_object_or_404(Keyword, id=keyword_id)
        
        serializer = KeywordWithFCMTokenSerializer(keywords) 
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def delete(self, request, keyword_id):
        # URL에서 uid를 추출
        user = get_object_or_404(KeywordWithFCMTokenSerializer, id=keyword_id)
        user.delete()
        
        return Response({"message": "키워드 삭제가 완료되었습니다"}, status=204)
    
class KeywordFCMTokenAPIView(APIView):
    
    #permission_classes = [IsAuthenticated]
    permission_classes = [AllowAny]
    authentication_classes = []
    def post(self, request, *args, **kwargs):
        host = request.data.get('host')
        name = request.data.get('name')
        fcm_token = request.data.get('fcm_token')

        keyword, created = Keyword.objects.get_or_create(host=host, name=name)

        fcm_token_instance = FCMToken.objects.create(keyword=keyword, fcm_token=fcm_token)
        serializer = FCMTokenOnlySerializer(fcm_token_instance)

        return Response(serializer.data)

    def delete(self, request, *args, **kwargs):
        # 쿼리 파라미터로부터 'host', 'name', 'fcm_token' 값을 가져옵니다.
        host = request.query_params.get('host')
        name = request.query_params.get('name')
        fcmToken = request.query_params.get('fcm_token')

        # 해당하는 Keyword 객체를 찾습니다.
        try:
            keyword = Keyword.objects.get(host=host, name=name)
        except Keyword.DoesNotExist:
            return Response({'message': '키워드를 찾지 못했습니다'}, status=status.HTTP_404_NOT_FOUND)

        # Keyword와 연관된 FCMToken을 찾아 삭제합니다.
        try:
            fcm_token = FCMToken.objects.get(keyword=keyword, fcm_token=fcmToken)
            fcm_token.delete()
            return Response({'message': "키워드 삭제가 완료되었습니다"}, status=status.HTTP_204_NO_CONTENT)
        except FCMToken.DoesNotExist:
            return Response({'message': '삭제할 키워드를 찾지 못했습니다'}, status=status.HTTP_404_NOT_FOUND)


class NotificationFCMTokenView(APIView):
    permission_classes = [AllowAny]
    authentication_classes = []
    def post(self, request, *args, **kwargs):
        hosts = hosts = request.data['hosts'] 
        fcm_token = request.data.get('fcm_token')

        for host in hosts:
            keyword, created = Keyword.objects.get_or_create(host=host, name='__all')
            fcm_token_instance = FCMToken.objects.create(keyword=keyword, fcm_token=fcm_token)
        
        return Response({"message": "학과 알림이 성공적으로 생성되었습니다."}, status=status.HTTP_200_OK) 
    
    def delete(self, request, *args, **kwargs):
        fcmToken = request.query_params.get('fcm_token')

        if not fcmToken:
            return Response({'message': 'FCM 토큰이 제공되지 않았습니다.'}, status=status.HTTP_400_BAD_REQUEST)
        
        # name이 '__all'인 Keyword 객체를 필터링
        keywords = Keyword.objects.filter(name='__all')

        deleted_count = FCMToken.objects.filter(keyword__in=keywords, fcm_token=fcmToken).delete()
        if deleted_count[0] == 0:
            return Response({'message': '삭제할 알림을 찾지 못했습니다'}, status=status.HTTP_404_NOT_FOUND)

        return Response({'message': "알림 삭제가 완료되었습니다"}, status=status.HTTP_204_NO_CONTENT)
    
class FCMTokenView(APIView):
    permission_classes = [AllowAny]
    def get(self, request, format=None):
        fcmTokens = FCMToken.objects.all() 
        serializer = FCMTokenOnlySerializer(fcmTokens, many=True) 
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def post(self, request, *args, **kwargs):

        serializer = FCMTokenOnlySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # 새로운 사용자 생성 또는 업데이트
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)
    
    def delete(self, request):
        # URL에서 uid를 추출
        token = request.query_params.get('fcm_token')

        fcm_tokens = FCMToken.objects.filter(fcm_token=token)
        # 해당하는 모든 객체 삭제
        fcm_tokens.delete()
        return Response({"message": "키워드 삭제가 완료되었습니다"}, status=204)
    
    def patch(self, request):
        # URL에서 uid를 추출
        token = request.query_params.get('fcm_token')
        onAlarm = request.query_params.get('on_alarm', 'false').lower() in ('true',)  # 불리언으로 변환

        fcm_tokens = FCMToken.objects.filter(fcm_token=token)
        # 해당하는 모든 객체의 on_alarm 값을 수정
        fcm_tokens.update(on_alarm=onAlarm)   
        
        return Response({"message": "키워드 수정이 완료되었습니다"}, status=200)    
    
class FCMTokenDetailView(APIView):
    permission_classes = [AllowAny]
    def get(self, request, id):
        fcmTokens = get_object_or_404(FCMToken, id=id)
        serializer = FCMTokenOnlySerializer(fcmTokens) 
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    
    
    
    
   
    
# class CBNUInfoUserView(APIView):
#     authentication_classes = [authentication.FirebaseAuthentication]
#     #permission_classes = [IsAuthenticated]

#     def get(self, request, format=None):
#         users = CBNUInfoUser.objects.all() 
#         serializer = CBNUInfoUserSerializer(users, many=True) 
#         return Response(serializer.data, status=status.HTTP_200_OK)
    
#     def post(self, request, *args, **kwargs):

#         serializer = CBNUInfoUserSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()  # 새로운 사용자 생성 또는 업데이트
#             return Response(serializer.data, status=201)
#         return Response(serializer.errors, status=400)
    
# class CBNUInfoUserDetailView(APIView):
#     authentication_classes = [authentication.FirebaseAuthentication]
#     #permission_classes = [IsAuthenticated]

#     def get(self, request, uid):
#         user = get_object_or_404(CBNUInfoUser, uid=uid)
#         serializer = CBNUInfoUserSerializer(user) 
#         return Response(serializer.data, status=status.HTTP_200_OK)
    
#     def delete(self, request, uid):
#         # URL에서 uid를 추출
#         user = get_object_or_404(CBNUInfoUser, uid=uid)
#         user.delete()
        
#         return Response({"message": "로그아웃이 완료되었습니다"}, status=204)
       

# class SubscribedView(APIView):
#     permission_classes = [IsAuthenticated]

#     def get(self, request, format=None):
#         user_id = self.kwargs['uid']
#         users = CBNUInfoUser.objects.filter(uid = user_id) 
#         serializer = UserWithSubscribedSerializer(users, many=True) 
#         return Response(serializer.data, status=status.HTTP_200_OK)
    
#     def post(self, request, *args, **kwargs):

#         serializer = UserWithSubscribedSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()  # 새로운 사용자 생성 또는 업데이트
#             return Response(serializer.data, status=201)
#         return Response(serializer.errors, status=400)
    
# class SubscribedDetailView(APIView):
#     permission_classes = [IsAuthenticated]

#     def get(self, request, id):
#         user_id = self.kwargs['uid']
#         user = get_object_or_404(Subscription, id=user_id)
#         serializer = SubscribedOnlySerializer(user) 
#         return Response(serializer.data, status=status.HTTP_200_OK)
    
#     def delete(self, request, id):
#         # URL에서 uid를 추출
#         user_id = self.kwargs['uid']
#         user = get_object_or_404(Subscription, id=user_id)
#         user.delete()
        
#         return Response({"message": "구독목록 삭제가 완료되었습니다"}, status=204)