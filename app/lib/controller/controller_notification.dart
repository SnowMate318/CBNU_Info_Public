import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class NotificationController extends GetxController{

  RxBool isNotify = false.obs;

  Future<void> addNotifications() async {
    MyInfo myInfo = Get.find();
    User user = myInfo.getUser();
    List<String> subscriptionList = myInfo.getSubscriptions();

    String? token = await user.getIdToken();
    debugPrint('$token');
    final header = {
      "Authorization": 'Bearer $token',
      "Content-Type": "application/json"
    };
    debugPrint(subscriptionList.toString());

    var body = jsonEncode({
      'hosts': subscriptionList,
      'fcm_token': token
    });

    var url = Uri.parse(
      'https://info.cbnu.ac.kr/api/notify/',
    );
    var response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      isNotify.value = true;
      debugPrint("알림 추가 성공");

    } else {
      //Todo: 실패 알림 구현
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}, message: ${response.body}');
    }

  }

  Future<void> deleteNotifications() async {

    MyInfo myInfo = Get.find();
    User user = myInfo.getUser();
    String? token = await user.getIdToken();
    debugPrint('$token');
    final header = {
      "Authorization": 'Bearer $token',
      "Content-Type": "application/json",
    };

    var url = Uri.parse(
      'https://info.cbnu.ac.kr/api/notify/',
    ).replace(queryParameters: {
      'fcm_token': token
    });

    var response = await http.delete(url, headers: header);
    if (response.statusCode == 204) {
      isNotify.value = false;
      debugPrint("데이터가 성공적으로 삭제되었습니다.");

    } else {
      //Todo: 실패 알림 구현

      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
  }
}