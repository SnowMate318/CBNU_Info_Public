import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulife_final/model/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../controller/controller_user.dart';

Future<InfoUser> initUser(User user) async {

  String? token = await user.getIdToken();
  final header = { "Authorization": 'Bearer $token'};
  var url = Uri.parse(
    'https://info.cbnu.ac.kr/api/user/${user.uid}/',
  );
  var response = await http.get(url, headers: header);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    InfoUser infoUser = InfoUser.init(
      uid: user.uid,
      fcmToken: jsonResponse['fcm_token'],
      subscriptions: prefs.getStringList('subscriptions')??[],
    );
    debugPrint(prefs.getStringList('subscriptions').toString());
    return infoUser;
  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }
}
Future<void> deleteUser(User user) async {
  MyInfo myInfo = Get.find();
  myInfo.resetInfo();
  String? token = await user.getIdToken(); // 사용자의 ID 토큰을 얻습니다.
  FirebaseMessaging.instance.deleteToken();
  var prefs = await SharedPreferences.getInstance();
  prefs.clear();
  final header = {
    "Authorization": 'Bearer $token', // 요청 헤더에 인증 정보를 포함합니다.
  };

  // 사용자의 UID를 사용하여 삭제할 사용자를 지정하는 URL을 구성합니다.
  var url = Uri.parse('https://info.cbnu.ac.kr/api/user/${user.uid}/');

  // HTTP DELETE 요청을 보냅니다.
  var response = await http.delete(url, headers: header);

  // 응답 상태 코드를 확인하여 요청의 성공 여부를 판단합니다.
  await FirebaseAuth.instance.signOut();

  if (response.statusCode == 204) {
    // 요청이 성공적으로 처리되었으나 반환할 콘텐츠는 없습니다.
    debugPrint("유저 정보가 성공적으로 삭제되었습니다");
  } else {
    // 요청 처리에 실패했습니다.
    throw Exception('HTTP request failed with status: ${response.statusCode}');
  }

}

Future<void> createUser() async {
  MyInfo myInfo = Get.find();
  await FirebaseAuth.instance.signInAnonymously();
  User user = FirebaseAuth.instance.currentUser!;
  String? token = await user.getIdToken();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("fcmtoken: ${fcmToken}");

  final header = {
    "Authorization": 'Bearer $token',
    "Content-Type": "application/json", // JSON 형식의 데이터를 보내고 있음을 명시
  };

  var url = Uri.parse('https://info.cbnu.ac.kr/api/user/');

  // 보내고자 하는 데이터를 JSON 형식으로 인코딩
  var body = jsonEncode({
    'uid': user.uid,
    'fcm_token': fcmToken,
    'subscriptions': [],
  });

  // HTTP POST 요청 보내기
  var response = await http.post(url, headers: header, body: body);

  if (response.statusCode == 201) {
    // 요청이 성공적으로 처리됨
    debugPrint("유저 정보가 성공적으로 저장되었습니다");
    myInfo.changeInfo(await initUser(user));
  } else {
    // 요청 처리 실패
    throw Exception('Failed to create user: ${response.statusCode}');
  }
}