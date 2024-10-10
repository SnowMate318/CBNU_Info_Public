class InfoUser{
  String uid;
  String fcmToken;
  List<String> subscriptions;
  //Todo: 나머지 정보들

  InfoUser.init({
    this.uid = '',
    this.fcmToken = '',
    this.subscriptions = const [],
  });

  InfoUser.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        fcmToken = json['fcm_token'] ?? '',
        subscriptions = json['subscriptions'] ?? [];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fcm_token': fcmToken,
      'subscriptions': subscriptions
    };
  }
//Todo: PATCH 요청 보내야함
}