import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulife_final/strings.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulife_final/model/user/user.dart';
import 'package:ulife_final/model/user/user_data.dart';
import 'package:http/http.dart' as http;
class MyInfo extends GetxController {
  InfoUser infoUser = InfoUser.init();
  User? user;

  Future<Map<String,String>> getFirebaseHeader()async{
    String? token = await user?.getIdToken();
    return {
      "Authorization": 'Bearer $token'

    };
  }

  User getUser(){
    return user!;
  }

  Future<void> fetch() async {
    user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      infoUser = await initUser(user!);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      infoUser.subscriptions = prefs.getStringList("subscriptions")??['씨앗', '충북대학교', '대외활동', '국비지원', '공모전'];
      debugPrint("배치 완료: ${infoUser.subscriptions.toString()}");


    } else {
      debugPrint("firebase auth 정보를 받아오지 못했습니다");
    }
  }
  void changeInfo(InfoUser newInfoUser){
    debugPrint(newInfoUser.uid);
    debugPrint(newInfoUser.fcmToken);
    infoUser = newInfoUser;
  }

  void resetInfo(){
    infoUser = InfoUser.init();
  }

  Future<void> updateInfoUserSubscriptions(List<String> newSubscriptions) async {
    infoUser.subscriptions = newSubscriptions;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("subscriptions", newSubscriptions);
  }

  String getUserFcmToken(){
    return infoUser.fcmToken;
  }

  List<String> getSubscriptions(){
    return infoUser.subscriptions;
  }


}