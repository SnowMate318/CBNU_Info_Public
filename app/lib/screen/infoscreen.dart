import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/tabview.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/viewoption.dart';
import '../component/info_screen/infoblock.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    String title = args?["title"] ?? "교내 활동";
    int? index = args?["index"] ?? 0;
    ViewOptionController viewOptionController = Get.find();
    TabviewItemController tabviewItemController = Get.find();
    tabviewItemController.title.value = title;
    tabviewItemController.index.value = index ?? 0;
    List<String> tabviewitems = tabviewItemController.getTabViewItems(title);
    MyTabController tabController = Get.put(MyTabController());

    final TabController _tabController = tabController.controller;

    List<Widget> hostWidgets = tabviewitems.map((String tabText) {
      return Container(child: Tab(text: tabText));
    }).toList();

    List<Widget> infoBlockWidgets = tabviewitems.map((String tabText) {
      return InfoBlock(
          headtitle: title,
          host: tabText,
          viewoption: viewOptionController.viewoption);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE_COLOR,
        surfaceTintColor: WHITE_COLOR,
        foregroundColor: BLACK_COLOR,
        elevation: 0.0,
        leading: Container(
          child: IconButton(
            onPressed: () {
              Get.back();
              Get.delete<TabBarView>();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: BLACK_COLOR,
              size: 24.0,
            ),
          ),
        ),
        title: const Text("정보 조회"),
        titleTextStyle: maintitlestyle,
        bottom: TabBar(
          isScrollable: true,
          tabs: hostWidgets,
          labelColor: BLACK_COLOR,
          labelStyle: selectedlabelstyle,
          unselectedLabelColor: DARK_GREY_COLOR,
          indicatorColor: BLACK_COLOR,
          controller: _tabController,
        ),
      ),

      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: infoBlockWidgets,
        ),
      ),
    );
  }
}
