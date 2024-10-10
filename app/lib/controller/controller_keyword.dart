import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ulife_final/controller/controller_user.dart';
import 'package:ulife_final/model/user/user.dart';

class KeywordController extends GetxController{
  RxList<String> keywordList = <String>[].obs;
  RxBool onAlarm = false.obs;
  RxInt keywordNum = 0.obs;

  MyInfo myInfo = Get.find();

  @override
  void onInit() async{
    super.onInit();
    onAlarm.value = await Permission.notification.status.isGranted;
    await fetchKeyword();
  }

  Future<void>fetchKeyword()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    keywordList.value = prefs.getStringList("keyword_list")??[];
    setKeywordNum();
  }

  Future<void> addKeyword(User user, String keyword) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        keywordList.add(keyword);
        keywordList.value = keywordList.toSet().toList();
        prefs.setStringList("keyword_list", keywordList);
        setKeywordNum();
        String? token = await user.getIdToken();
        final header = {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json"
        };
        debugPrint(myInfo.getSubscriptions().toString());

        for (String host in myInfo.getSubscriptions()) {
          var body = jsonEncode({
            'host': host,
            'name': keyword,
            'fcm_token': myInfo.infoUser.fcmToken
          });

          var url = Uri.parse(
            'https://info.cbnu.ac.kr/api/keyword/',
          );
          var response = await http.post(url, headers: header, body: body);
          if (response.statusCode == 200) {

            debugPrint("추가 성공");
          } else {
            //Todo: 실패 알림 구현
            throw Exception(
                'HTTP request failed with status: ${response.statusCode}');
          }
        }

    }
  Future<void> addAllKeyword(User user, List<String> newKeywordList, List<String> subscriptionList) async {

    for(String keyword in newKeywordList) {
      String? token = await user.getIdToken();
      final header = {
        "Authorization": 'Bearer $token',
        "Content-Type": "application/json"
      };
      debugPrint(subscriptionList.toString());

      for (String host in subscriptionList) {
        var body = jsonEncode({
          'host': host,
          'name': keyword,
          'fcm_token': myInfo.infoUser.fcmToken
        });

        var url = Uri.parse(
          'https://info.cbnu.ac.kr/api/keyword/',
        );
        var response = await http.post(url, headers: header, body: body);
        if (response.statusCode == 200) {

          debugPrint("추가 성공");
        } else {
          //Todo: 실패 알림 구현
          throw Exception(
              'HTTP request failed with status: ${response.statusCode}');
        }
      }
    }
  }


  Future<void> deleteKeyword(User user, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String removeKeyword = keywordList[index];
    keywordList.removeAt(index);
    prefs.setStringList("keyword_list", keywordList);
    setKeywordNum();

    String? token = await user.getIdToken();
    final header = {
      "Authorization": 'Bearer $token',
      "Content-Type": "application/json",
    };

    for (String host in myInfo.infoUser.subscriptions) {

      var url = Uri.parse(
        'https://info.cbnu.ac.kr/api/keyword/',
      ).replace(queryParameters: {
        'host': host,
        'name': removeKeyword,
        'fcm_token': myInfo.infoUser.fcmToken
      });

      var response = await http.delete(url, headers: header);
      if (response.statusCode == 204) {
       debugPrint("데이터가 성공적으로 삭제되었습니다.");
      } else {
        //Todo: 실패 알림 구현
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }
    }
  }
  //Todo: 계정 삭제시 cascade가 안됨(따로 처리해야함)

  Future<void> deleteAllKeyword(User user, String fcmToken, bool resetPref)async{

    if(resetPref){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("keyword_list", []);

    }

    String? token = await user.getIdToken();

    final header = {
      "Authorization": 'Bearer $token',
      "Content-Type": "application/json",
    };

    var url = Uri.parse(
      'https://info.cbnu.ac.kr/api/fcmtoken/',
    ).replace(queryParameters: {
      'fcm_token' : fcmToken,
    });

      var response = await http.delete(url, headers: header);
      if (response.statusCode == 204) {
        debugPrint("데이터가 성공적으로 삭제되었습니다.");
      } else {
        //Todo: 실패 알림 구현
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }

  }


  Future<void> switchAlarm(User user, bool value, String fcmToken) async {
      final status = await Permission.notification.status.isGranted;
      if(!status && value){
        debugPrint("status: ${status}, value: ${value}");
        var tmp = await Permission.notification.status;
        String tmp2 = tmp.toString();
        debugPrint(tmp2);
        await Permission.notification.request();

      }
      else {
        String? token = await user.getIdToken();

        final header = {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json",
        };
        String alarmQuery = value ? "true" : "false";
        var url = Uri.parse(
          'https://info.cbnu.ac.kr/api/fcmtoken/',
        ).replace(queryParameters: {
          'fcm_token' : fcmToken,
          'on_alarm' : alarmQuery,
        });

        var response = await http.patch(url, headers: header);
        if (response.statusCode == 200) {
          debugPrint("데이터가 성공적으로 수정되었습니다.");
        } else {
          //Todo: 실패 알림 구현
          throw Exception(
              'HTTP request failed with status: ${response.statusCode}');
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('on_keyword_alarm', value);
        onAlarm.value = value;
      }


  }
  //@키워드 갯수 변경
  void setKeywordNum() {
    keywordNum.value = keywordList.length;
  }

}
