// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:umarket/controller/user.dart';
// import 'package:umarket/model/team/chat.dart';
// import 'package:umarket/model/team/chat_data.dart';
// import 'package:umarket/model/team/team.dart';
// import 'package:umarket/model/team/team_data.dart';
//
// Future<String> getFcmToken() async {
//   return await (FirebaseMessaging.instance.getToken()) ?? '';
// }
//
// Future<void> checkFcmTokenRefresh() async {
//   MyInfo myInfo = Get.find();
//   String token = await getFcmToken();
//
//   debugPrint('get FCM Token: $token');
//   //FCM token이 refresh 된 경우
//   if (myInfo.customer.fcmToken != token) {
//     await _updateFcmToken(token);
//   }
//
//   _registerFcmTokenListener();
// }
//
// //FCM 토큰이 변경되는 경우(새로운 기기에서 로그인 등),
// //기존 Customer/Team/Chat의 모든 토큰 정보를 업데이트 함.
//
//
// void _registerFcmTokenListener() {
//   FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
//   });
// }