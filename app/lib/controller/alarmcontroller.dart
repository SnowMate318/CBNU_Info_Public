import 'package:get/get.dart';
import 'package:flutter/material.dart';
class AlarmController extends GetxController
{
  RxBool onAlarm = false.obs;
  RxList<RxString> keywordList = <RxString>[].obs;
  RxInt keywordNum = 0.obs;
  String keyword = "";
  final keywordFormKey = GlobalKey<FormState>();
  final keywordController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    //Todo: 서버 요청 추가
    keywordList.addAll(["key1".obs, "key2".obs, "key3".obs]); //Todo: 추후 서버 요청으로 수정
    setKeywordNum(keywordList.length);
    super.onInit();
  }

  @override
  void onClose() {
    keywordController.dispose();
    super.onClose();
  }

  String? validator(String? value) {
    if (value!.isEmpty || value == null) {
      return '키워드를 입력해주세요';
    }
    return null;
  }

  RxString getKeywordList(int index){
    return keywordList[index];
  }

  //@키워드 변경
  void setKeyword(int index, String keyword)
  {
    keywordList[index].value = keyword;
  }

  //@ 키워드 추가
  void addKeyword()
  {
    if(keywordFormKey.currentState != null && keywordFormKey.currentState!.validate()){
      keywordList.add(keyword.obs);
      //Todo: 서버 요청 추가
    } else {
      print("Invalid Keyword");
    }
  }
  //@ 키워드 제거
  void removeKeyword(int index){
    keywordList.removeAt(index);
    //Todo: 서버 요청 추가
  }

  //@ 알림 토글
  void toggleAlarm(){
    onAlarm.value = !onAlarm.value;
    //Todo: 서버 요청 추가
  }

  //@키워드 갯수 변경
  void setKeywordNum(int num)
  {
    keywordNum.value = num;
  }

}

