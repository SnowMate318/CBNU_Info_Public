import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// 메인페이지 버튼
Future<void> handleButtonPress() async{
  await analytics.logEvent(
    name: 'click_menu_button',
  );
}

//
Future<void> handleSubscriptions(String subscription) async {
  await analytics.logEvent(
    name: 'set_user_subscriptions',
    parameters: <String, dynamic>{
      '구독 목록': subscription,
    },
  );
}
//
Future<void> handleKeywords(String keyword) async {
  await analytics.logEvent(
    name: 'set_user_notify_keyword',
    parameters: <String, dynamic>{
      'string': keyword,
    },
  );
}

Future<void> handleSwitchActivityOnOff(String activity, bool onOff)async {
  int num = onOff == true ? 1 : 0;
  await analytics.logEvent(
    name: 'set_user_activity_switch',
    parameters: <String, dynamic>{
      '활동': activity,
      '스위치': num
    },
  );
}

// 메인페이지 버튼
Future<void> handleAlarmOnOff(bool onOff) async{
  int num = onOff == true ? 1 : 0;
  await analytics.logEvent(
    name: 'activate_user_alarm',
    parameters: <String, dynamic>{
      '스위치': num,
    },
  );
}