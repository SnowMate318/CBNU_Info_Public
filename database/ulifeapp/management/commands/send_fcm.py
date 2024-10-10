from django.core.management.base import BaseCommand
from ulifeapp.models import KeywordNotification, Keyword, FCMToken
from ulifeapp.serializers import KeywordNotificationSerializer, FCMTokenOnlySerializer
from firebase_admin import messaging
from rest_framework import status

def send_to_firebase_cloud_messaging(host, announceTitle, fcmTokens, deepLink):
    # This registration token comes from the client FCM SDKs.
    #registration_token = fcmToken,
    
    # See documentation on defining a message payload.
    
    message = messaging.MulticastMessage(
    data={
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',  # 필요에 따라 변경 가능
        'deep_link': deepLink ,
        'image' : 'https://firebasestorage.googleapis.com/v0/b/cbnuinfo.appspot.com/o/en_bom.png?alt=media&token=309ea9dc-2690-4310-b3ea-88c3a9b550d3',
    },
    tokens=fcmTokens,
    notification=messaging.Notification(
        title= host,
        body=announceTitle,
        ),
    )
    
    response = messaging.send_multicast(message)
    # Response is a message ID string.
    print('Successfully sent message:', response)

class Command(BaseCommand):
    help = 'Send FCM notifications to users based on their subscribed keywords'

    def handle(self, *args, **options):
        # SendFCMNotificationView의 로직을 여기에 구현
        # 위에서 정의한 SendFCMNotificationView.get의 로직을 여기에 복사 및 붙여넣기
        # 예를 들어:
        keyword_notifications = KeywordNotification.objects.all()
        serializer = KeywordNotificationSerializer(keyword_notifications, many=True)
        # 나머지 로직을 계속 구현...
        
        for map in serializer.data:
            host = map['host']
            title = map['title']
            url = map['url']
            
            tokenList = title.split()
            for token in tokenList:
                keywords = Keyword.objects.filter(host=host, name__contains=token)
                for keyword in keywords:
                    fcmTokens = FCMToken.objects.filter(keyword=keyword, on_alarm=True)
                    fcmtokenSerializer = FCMTokenOnlySerializer(fcmTokens, many=True)
                    
                    tokens = []
                    for fcmToken in fcmtokenSerializer.data:
                        tokens.append(fcmToken['fcm_token'])
                    send_to_firebase_cloud_messaging(host, title, tokens, url)  # fcmToken['token']을 적절히 수정해야 할 수 있습니다.
        
        print(f"FCM Notifications sent successfully  status: {status.HTTP_200_OK}")
        
        delete_count, _ = KeywordNotification.objects.all().delete()
        print(f"Deleted {delete_count} KeywordNotification entries.")