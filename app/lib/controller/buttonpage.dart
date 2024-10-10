import 'package:get/get.dart';
import 'package:ulife_final/controller/controller_keyword.dart';
import 'package:ulife_final/controller/controller_user.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/viewoption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulife_final/analytics.dart';
import 'package:flutter/material.dart';

class ButtonPageController extends GetxController {
  var entireMajor = <String>[].obs;
  var majors = <String>[].obs;
  var dorms = <String>[].obs;
  var viewoption = "전체".obs;
  //RxInt? selectvalue = 0.obs;
  RxInt majorvalue = 100000.obs;
  RxMap values = {}.obs;
  TabviewItemController tabviewItemController = Get.find();
  ViewOptionController viewOptionController = Get.find();

  @override
  void onInit() async{
    super.onInit();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    majors.value = prefs.getStringList("defaultmajorlist")??[];
    dorms.value = prefs.getStringList("defaultdormlist")??[];
    viewoption.value = prefs.getString("defaultviewoption")??"전체";

    switch(viewoption.value)
    {
      case "전체":
        values["글 보기"] = 0;
        break;
      case "최근 1주일":
        values["글 보기"] = 1;
        break;
      case "최근 1달":
        values["글 보기"] = 2;
        break;
    }
  }



  void addMajors(String str) {
    Set<String> tmp = majors.toSet();
    tmp.add(str);
    majors.value = tmp.toList();
  }

  void removeMajors(String str) {
    Set<String> tmp = majors.toSet();
    tmp.remove(str);
    majors.value = tmp.toList();
  }

  void setMajors(List<String> liststr){
    Set<String>tmp = liststr.toSet();
    majors.value = tmp.toList();
  }

  void addDorms(String str) {
    Set<String> tmp = dorms.toSet();
    tmp.add(str);
    dorms.value = tmp.toList();
  }

  void removeDorms(String str) {
    Set<String> tmp = dorms.toSet();
    tmp.remove(str);
    dorms.value = tmp.toList();
  }

  void setDorms(List<String> liststr){
    Set<String>tmp = liststr.toSet();
    dorms.value = tmp.toList();
  }

  void setViewOption(String str) {
    viewoption.value = str;
  }

  List<String> getNewSubscriptions() {
    List<String> newKeywordList = [];
    newKeywordList.addAll(majors);
    if(dorms.isNotEmpty){
      newKeywordList.add('기숙사');
    }
    newKeywordList.addAll(['씨앗', '충북대학교', '대외활동', '국비지원', '공모전']);
    return newKeywordList;
  }

  Future<void> updateKeyword()async{
    KeywordController keywordController = Get.find();
    MyInfo myInfo = Get.find();
    List<String> tmpKeywordList = keywordController.keywordList;
    await keywordController.deleteAllKeyword(myInfo.user!, myInfo.infoUser.fcmToken, false);
    debugPrint(tmpKeywordList.toString());
    await myInfo.updateInfoUserSubscriptions(getNewSubscriptions());
    await keywordController.addAllKeyword(myInfo.user!, tmpKeywordList, myInfo.getSubscriptions());
  }

  Future<void> sendAnalyticsSubscriptions() async {
    List<String> subscriptionList = [];
    subscriptionList.addAll(majors);
    subscriptionList.addAll(dorms);

    for(String subscription in subscriptionList){
      handleSubscriptions(subscription);
    }
  }

  Future<void> apply() async {
    tabviewItemController.setMajor(majors.toSet());
    tabviewItemController.setDorm(dorms.toSet());
    viewOptionController.setViewOption(viewoption.value);
    tabviewItemController.updateMajor();
    tabviewItemController.updateDorm();
    await sendAnalyticsSubscriptions();
    viewOptionController.viewOptionUpdate();
    await updateKeyword();
  }
}