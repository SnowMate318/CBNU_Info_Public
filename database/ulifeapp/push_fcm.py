
from firebase_admin import messaging
from .models import KeywordNotification, Keyword, FCMToken
from .serializers import KeywordNotificationSerializer, FCMTokenOnlySerializer

def send_to_firebase_cloud_messaging(host, announceTitle, fcmToken, deepLink):
    # This registration token comes from the client FCM SDKs.
    #registration_token = fcmToken,
    data={
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',  # 필요에 따라 변경 가능
            'deep_link': deepLink,
        },
    # See documentation on defining a message payload.
    message = messaging.Message(
    notification=messaging.Notification(
        title= host,
        body=announceTitle,
        ),
        token=fcmToken,
        #image = 'https://firebasestorage.googleapis.com/v0/b/cbnuinfo.appspot.com/o/en_bom.png?alt=media&token=309ea9dc-2690-4310-b3ea-88c3a9b550d3',
    )

    response = messaging.send(message)
    # Response is a message ID string.
    print('Successfully sent message:', response)

# keyword_notifications = KeywordNotification.objects.all()
# serializer = KeywordNotificationSerializer(keyword_notifications, many=True)

# for map in serializer.data:
#     host = map['host']
#     title = map['title']
#     url = map['url']
    
#     tokenList = title.split()
#     for token in tokenList:
#         keywords = Keyword.objects.filter(host=host, name__contains=token)
#         for keyword in keywords:
#             fcmTokens = FCMToken.objects.filter(keyword = keyword)
#             fcmtokenSerializer = FCMTokenOnlySerializer(fcmTokens, many=True)
            
#             for fcmToken in fcmtokenSerializer.data:
#                 send_to_firebase_cloud_messaging(host, title, fcmToken, url)
        
    
    

# 크론