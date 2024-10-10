import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tabviewitem.dart';

class MyTabController extends GetxController with GetSingleTickerProviderStateMixin {

  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    TabviewItemController tabviewItemController = Get.find();
    List<String> tabviewitems = tabviewItemController.getTabViewItems(tabviewItemController.title.value);
    controller = TabController(vsync: this, length: tabviewitems.length, initialIndex: tabviewItemController.index.value);

    ever(tabviewItemController.index, handleIndexChange);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

    void handleIndexChange(int idx) {
    controller.animateTo(idx);
  }
}