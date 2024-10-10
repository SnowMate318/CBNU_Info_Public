import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ulife_final/analytics.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/logincontroller.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/viewoption.dart';
import 'package:ulife_final/screen/subscribescreen.dart';
import 'package:ulife_final/controller/buttonpage.dart';
import 'package:ulife_final/controller/mainscreencontroller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ulife_final/const/style.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ViewOptionController viewOptionController = Get.find();
    TabviewItemController tabviewItemController = Get.find();
    LoginController loginController = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE_COLOR,
        surfaceTintColor: WHITE_COLOR,
        foregroundColor: BLACK_COLOR,
        elevation: 0.0,
        leading: SizedBox(
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: BLACK_COLOR,
              size: 24.0,
            ),
          ),
        ),
        title: const Text("설정"),
        titleTextStyle: maintitlestyle,
      ),
      body: SafeArea(
        child: Obx(() {
          String viewoption = viewOptionController.viewoption;
          String majorString = tabviewItemController.getMajorString();
          String dormString = tabviewItemController.getDormString();
          List<String> optionlist = ["교내 활동", "교외 활동", "오늘의 메뉴"];
          return ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    const SizedBox(height: 8.0),
                    Container(
                      color: WHITE_COLOR,
                      child: Column(
                        children: [
                          ListTile(
                              title: const Text(
                                "구독 정보",
                                style: minititlestyle,
                              ),
                              //leading: Icon(Icons.space_dashboard_outlined),
                              leading: const Icon(Icons.contact_page_outlined),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_box_outlined),
                                onPressed: () {
                                  Get.toNamed('/subscribe');
                                },
                              )),
                          ListTile(
                              title: const Text('소속 학과/학부'),
                              //leading: const Icon(Icons.contact_page_outlined),
                              leading: const SizedBox(),
                              //왼쪽 끝
                              trailing: SizedBox(
                                child: Text(
                                  majorString,
                                  style: selectedliststyle,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ) //오른쪽 끝
                              ),
                          ListTile(
                              title: const Text('기숙사'),
                              leading: const SizedBox(),
                              //왼쪽 끝
                              trailing: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: Text(
                                  dormString,
                                  style: selectedliststyle,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ) //오른쪽 끝
                              ),
                          ListTile(
                              title: const Text('글 보기'),
                              leading: const SizedBox(),
                              //왼쪽 끝
                              trailing: Container(
                                child: Text(
                                  viewoption,
                                  style: selectedliststyle,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                color: WHITE_COLOR,
                child: Column(
                  children: [
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
                          leading: const SizedBox(),
                          title: Text(
                            optionlist[index],
                            style: optionstyle,
                          ),
                          trailing: _buildStateSwitch(optionlist[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                color: WHITE_COLOR,
                child: Column(
                  children: [
                    _buildInqueryButton(context),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          loginController.logout();
                        },
                        child: const Text(
                          "로그아웃",
                          style: logoutbuttonstyle,
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStateSwitch(String title) {
    MainScreenController mainScreenController = Get.find();
    return Obx(
      () => Switch(
        value: mainScreenController.selectlist[title] ?? true,
        activeColor: const Color.fromRGBO(125, 34, 72, 1.0),
        onChanged: (value) {
          mainScreenController.toggleSwitch(title, value);
          handleSwitchActivityOnOff(title, value);
        },
      ),
    );
  }

  Widget _buildInqueryButton(BuildContext context) {
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
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: InkWell(
                onTap: () {
                  _launchURL("https://open.kakao.com/o/g9GDjGlg");
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: DARK_GREY_COLOR),
                      //shape: BoxShape.circle
                    ),
                    child: const Center(
                      child: Text(
                        "1:1 문의하기",
                        style: inquerytextstyle,
                        textAlign: TextAlign.center,
                      ),
                    )))));
  }
}
