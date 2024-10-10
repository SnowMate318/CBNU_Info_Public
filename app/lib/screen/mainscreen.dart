import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/component/main_screen/block.dart';
import 'package:ulife_final/component/main_screen/foodblock.dart';
import 'package:ulife_final/controller/alarmcontroller.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/viewoption.dart';
import 'package:ulife_final/screen/alarmpage.dart';
import 'package:ulife_final/screen/settingscreen.dart';
import 'package:ulife_final/widget/drawer.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/analytics.dart';
import 'package:ulife_final/listdata/classinfo.dart';
import 'package:ulife_final/controller/mainscreencontroller.dart';
import '../const/colors.dart';
import '../controller/logincontroller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final ViewOptionController viewOptionController = Get.find();
  final TabviewItemController tabviewItemController = Get.find();
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Get.put(MainScreenController());
    MainScreenController mainScreenController = Get.find();

    List<String> mainscreentitles = ["교내 활동", "교외 활동", "오늘의 메뉴"];

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    var data = mainScreenController.selectedData;
    return Obx(() {
      if (mainScreenController.isInitialized.value) {
        return Scaffold(
            body: SafeArea(
          child: Container(
            color: WHITE_COLOR,
            child: Center(
                child: SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator())),
          ),
        ));
      } else {
        return Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(64.0),
              child: AppBar(
                backgroundColor: WHITE_COLOR,
                surfaceTintColor: WHITE_COLOR,
                foregroundColor: BLACK_COLOR,
                elevation: 0.0,
                leading: Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                    child: Image.asset(
                      'assets/images/en_bom.png',
                    )),
                // title: Padding(
                //     padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                //     child: const Text("충북대학교 종합정보서비스")),
                // titleTextStyle: maintitlestyle,
                // bottom: PreferredSize(
                //   preferredSize: const Size.fromHeight(1.0),
                //   child: Divider(color: Colors.grey[500]),
                // ),
                iconTheme: const IconThemeData(
                  color: Colors.black,
                  size: 24.0,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(AlarmPage(), binding: BindingsBuilder(() {
                        Get.put(AlarmController());
                      }));
                    },
                    icon: Icon(Icons.alarm),
                  ),
                  IconButton(
                    onPressed: () async {
                      // await handleButtonPress();
                      // _scaffoldKey.currentState?.openEndDrawer();
                      Get.to(SettingScreen());
                    },
                    icon: Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
            //endDrawer: DrawerWidget(context),
            body: SafeArea(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              //color: Colors.white,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  List<List<Data>> blocklist = [];
                  List<Food> foodblocklist = [];
                  for (dynamic val in data.keys.toList()) {
                    if (val == "오늘의 메뉴") {
                      foodblocklist = data[val];
                    } else {
                      blocklist.add(data[val]);
                    }
                  }
                  return mainscreentitles[index] != "오늘의 메뉴"
                      ? Block(
                          viewoption: viewOptionController.viewoption,
                          title: mainscreentitles[index],
                          datalist: blocklist[index],
                        )
                      : FoodBlock(
                          hostlist:
                              tabviewItemController.getMainCafeteriaList(),
                          title: mainscreentitles[index],
                          datalist: foodblocklist);
                },
              ),
            )));
      }
    });
  }
}
