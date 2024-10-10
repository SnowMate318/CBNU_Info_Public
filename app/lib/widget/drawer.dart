import 'package:flutter/material.dart';
import 'package:ulife_final/analytics.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/logincontroller.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/viewoption.dart';

import 'package:ulife_final/controller/buttonpage.dart';
import 'package:ulife_final/controller/mainscreencontroller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ulife_final/const/style.dart';
import 'package:get/get.dart';

Widget DrawerWidget(BuildContext context){
  double layout_width = 300 < MediaQuery.of(context).size.width*0.5 ? MediaQuery.of(context).size.width*0.5 :300;
  ViewOptionController viewOptionController = Get.find();
  TabviewItemController tabviewItemController = Get.find();
  LoginController loginController = Get.find();

  return Obx((){
    String viewoption = viewOptionController.viewoption;
    String majorString = tabviewItemController.getMajorString();
    String dormString = tabviewItemController.getDormString();
    List<String> optionlist = ["교내 활동", "교외 활동", "오늘의 메뉴"];
    return
      SizedBox(
          width: layout_width,
            child: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        '설정',
                        textAlign: TextAlign.center,
                        style: settingtitlestyle,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, height: 1, color: GREY_COLOR),
                  InkWell(
                      onTap: () {

                        Get.toNamed('/setting');
                      },
                      child: Column(
                        children: [
                          ListTile(
                              title: const Text('소속 학과/학부'),
                              leading: const Icon(Icons.contact_page_outlined), //왼쪽 끝
                              trailing: SizedBox(
                                width: MediaQuery.of(context).size.width*0.20,
                                child: Text(
                                  majorString,
                                  style: selectedliststyle,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ) //오른쪽 끝
                          ),
                          const Divider(thickness: 1, height: 1, color: GREY_COLOR),
                          ListTile(
                              title: const Text('기숙사'),
                              leading: const Icon(Icons.contact_page_outlined), //왼쪽 끝
                              trailing: SizedBox(
                                width: MediaQuery.of(context).size.width*0.20,
                                child: Text(
                                  dormString,
                                  style: selectedliststyle,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )  //오른쪽 끝
                          ),
                          const Divider(thickness: 1, height: 1, color: GREY_COLOR),
                          ListTile(
                              title: const Text('글 보기'),
                              leading: const Icon(Icons.contact_page_outlined), //왼쪽 끝
                              trailing: Container(
                                width: MediaQuery.of(context).size.width*0.20,
                                child: Text(
                                  viewoption,
                                  style: selectedliststyle,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ),
                        ],
                      )),
                  const Divider(thickness: 1, height: 1, color: GREY_COLOR),
                  const ListTile(
                    title: Text(
                      "홈 화면 설정",
                      style: minititlestyle,
                    ),
                    leading: Icon(Icons.remove_red_eye_outlined),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: optionlist.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          optionlist[index],
                          style: optionstyle,
                        ),
                        trailing: stateSwitch(
                          optionlist[index]
                        ),
                      );
                    },
                  ),
                  const Divider(thickness: 1, height: 1, color: GREY_COLOR),
                  const SizedBox(height: 40),
                  inqueryButton(layout_width),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: (){
                        loginController.logout();
                      },
                      child: const Text(
                        "로그아웃",
                        style: logoutbuttonstyle,
                      )
                  )
                ],
              ),
            ),
          );
  });
}

Widget stateSwitch(String title){
  MainScreenController mainScreenController = Get.find();
  return Obx(
        () => Switch(
      value: mainScreenController.selectlist[title]??true,
      activeColor: const Color.fromRGBO(125, 34, 72,1.0),
      onChanged: (value) {
        mainScreenController.toggleSwitch(title, value);
        handleSwitchActivityOnOff(title, value);
      },
    ),
  );
}

Widget inqueryButton(double width){
  void _launchURL(String? url) async {
    String finalURL = url ?? "";
    if (await canLaunch(finalURL) && finalURL != "") {
      await launch(finalURL);
    } else if (finalURL == "") {
      print("URL NOT REFLECTED");
    } else {
      throw 'Could not launch $finalURL';
    }
  }
  return Center(
      child:Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: InkWell(
              onTap: () {
                _launchURL("https://open.kakao.com/o/g9GDjGlg");
              },
              child: Container(
                  width: width*0.9,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2,color: DARK_GREY_COLOR),
                    //shape: BoxShape.circle
                  ),
                  child: const Text(
                    "문의하기",
                    style: applytextstyle,
                    textAlign: TextAlign.center,
                  )
              )
          )
      )
  );


}
