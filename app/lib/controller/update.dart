import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'announcement.dart';

class MyScrollController extends GetxController{
  RxBool isMoreRequesting = false.obs;
  var scrollController = ScrollController().obs;
  RxString currentHost = "충북대학교".obs;
  RxString currentViewOption = "전체".obs;
  //RxSet<Data> currentData = <Data>{}.obs;

  CampusAnnController campusAnnController = Get.find();
  ExtracurAnnController extracurAnnController = Get.find();
  CieatController cieatController = Get.find();

  @override
  void onInit() {
    super.onInit();
    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent) {
        callAPI();
      }
    });
  }
  void refreshController(String host, String viewoption){
    isMoreRequesting.value = false;
    currentHost.value = host;
    currentViewOption.value = viewoption;
  }
  Future<void> callAPI() async {
    var host = currentHost.value;
    var viewoption = currentViewOption.value;

      isMoreRequesting.value = true;
      switch (host) {
        case "씨앗":
          CieatController cieatController = Get.find();
          await cieatController.updateCieat(viewoption, null);
          break;
        case "대외활동":
        case "국비교육":
        case "공모전":
          ExtracurAnnController extracurAnnController = Get.find();
          await extracurAnnController.updateExternalAnnouncement(viewoption, null, host);
          break;
        default:
          CampusAnnController campusAnnController = Get.find();
          await campusAnnController.updateCampusAnnouncement(host, viewoption, null);
          break;
      }
      isMoreRequesting.value = false;
  }
}