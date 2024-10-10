
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/component/data_input_screen/button_block.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/buttonpage.dart';
import 'package:ulife_final/controller/controller_notification.dart';
import 'package:ulife_final/controller/mainscreencontroller.dart';
import 'package:ulife_final/listdata/listdata.dart';
import 'package:get/get.dart';
import 'package:ulife_final/analytics.dart';
import '../controller/controller_keyword.dart';
import '../controller/controller_user.dart';

ListData lsta = ListData();
final List<String> dormlist = lsta.dormlist;
final List<String> optionlist = lsta.taglist;
final List<String> titlelist = lsta.selecttitlelist;
List<List<String>> listdata = lsta.getOptionBlock();
List<String> departmentlist = lsta.departmentlist;

class SbuscribeScreen extends StatefulWidget {
  const SbuscribeScreen({Key? key}) : super(key: key);

  @override
  State<SbuscribeScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SbuscribeScreen> {
  late ButtonPageController buttonPageController;
  late KeywordController keywordController;
  late NotificationController notificationController;
  late MyInfo myInfo;
  late String fcmToken;
  late User user;
  bool isLoading = false;
  @override
  void initState() {
    Get.put(ButtonPageController());
    buttonPageController = Get.find();
    keywordController = Get.find();
    myInfo = Get.find();
    notificationController = Get.find();
    fcmToken = myInfo.getUserFcmToken();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    user = FirebaseAuth.instance.currentUser!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          backgroundColor: WHITE_COLOR,
          foregroundColor: BLACK_COLOR,
          elevation: 0.0,
          leading: Container(
            //padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
            child: IconButton(
                onPressed: () {
                  Get.delete<ButtonPageController>();
                  Get.back();

                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: BLACK_COLOR,
                  size: 24.0,
                )),
          ),
          title: const Text(
            "구독 정보",
          ),
          titleTextStyle: maintitlestyle,
          iconTheme: const IconThemeData(
            color: BLACK_COLOR,
            size: 24.0,
          ),
        ),),

      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height,
              //color: WHITE_COLOR,
              child: SingleChildScrollView(
                child: Column(

                  children: [
                    ListTile(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
                        tileColor: WHITE_COLOR,
                        title: const Text(
                          "알림 설정",
                          style: alarmTitleStyle,
                        ),
                        trailing: Obx(() {
                          return Switch(
                              value: keywordController.onAlarm.value,
                              onChanged: (value) async {
                                await handleAlarmOnOff(value);
                                keywordController.switchAlarm(user, value, fcmToken);
                              });
                        })),
                    ListTile(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0))),
                        tileColor: WHITE_COLOR,
                        leading: const Text(
                          "구독 알림 설정",
                          style: alarmTitleStyle,
                        ),
                        title: const Text(
                          "설정한 학과에 새 글이 올라왔을 경우 알림을 받습니다.",
                          softWrap: true,
                          style: alarmexplainationstyle,
                        ),
                        trailing: Obx(() {
                          return Switch(
                              value: notificationController.isNotify.value,
                              onChanged: (value) async {
                                if(keywordController.onAlarm.value){
                                  if(value){
                                    notificationController.addNotifications();
                                  } else {
                                    notificationController.deleteNotifications();
                                  }
                                } else {

                                }
                              });
                        })),
                    SizedBox(height: 20.0),
                    ButtonBlock(
                      title: titlelist[0],
                      buttonList: listdata[0],
                    ),
                    SizedBox(height: 20.0),
                    ButtonBlock(
                      title: titlelist[1],
                      buttonList: listdata[1],
                    ),
                    SizedBox(height: 20.0),
                    ButtonBlock(
                      title: titlelist[2],
                      buttonList: listdata[2],
                    ),
                    SizedBox(height: 20.0),

                  ],
                ),
              ))),
      floatingActionButton: FilledButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          await buttonPageController.apply();
          setState(() {
            isLoading = false;
          });
          Get.find<MainScreenController>().refresh();
          Get.back();
        },
        child: isLoading ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ) : Text("적용하기",
            style: applytextstyle),
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color?>(
              const Color.fromRGBO(125, 34, 72,1.0),),
            //
      ),
    )

    );
  }
}


// class SettingScreen2 extends StatelessWidget {
//   const SettingScreen2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     Get.put(ButtonPageController());
//     ButtonPageController buttonPageController = Get.find();
//
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(64.0),
//         child: AppBar(
//         backgroundColor: WHITE_COLOR,
//         foregroundColor: BLACK_COLOR,
//         elevation: 0.0,
//         leading: Container(
//           //padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
//           child: IconButton(
//               onPressed: () {
//                 Get.delete<ButtonPageController>();
//                 Get.back();
//
//               },
//               icon: const Icon(
//                 Icons.arrow_back,
//                 color: BLACK_COLOR,
//                 size: 32.0,
//               )),
//         ),
//         centerTitle: true,
//         title: Padding(padding: EdgeInsets.fromLTRB(0, 8,  0, 0),
//          child: const Text("충북대학교 종합정보서비스")
//          ),
//         titleTextStyle: maintitlestyle,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Divider(color: GREY_COLOR),
//         ),
//         iconTheme: const IconThemeData(
//           color: BLACK_COLOR,
//           size: 32.0,
//         ),
//       ),),
//
//       body: SafeArea(
//           child: Container(
//               height: MediaQuery.of(context).size.height - 80,
//               color: WHITE_COLOR,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     ButtonBlock(
//                       title: titlelist[0],
//                       buttonList: listdata[0],
//                     ),
//                     ButtonBlock(
//                       title: titlelist[1],
//                       buttonList: listdata[1],
//                     ),
//                     ButtonBlock(
//                       title: titlelist[2],
//                       buttonList: listdata[2],
//                     ),
//                     SizedBox(height: 20.0),
//                     Padding(
//                         padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
//                         child: FilledButton(
//                           onPressed: () async {
//                             await buttonPageController.apply();
//                             Get.delete<ButtonPageController>();
//                             Get.find<MainScreenController>().refresh();
//                             Get.back();
//
//                           },
//                           child: Text("적 용 하 기",
//                               style: applytextstyle),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStatePropertyAll<Color?>(
//                                   const Color.fromRGBO(125, 34, 72,1.0),),
//                               fixedSize: MaterialStatePropertyAll<Size?>(Size(
//                                   MediaQuery.of(context).size.width * 0.8,
//                                   60))),
//                         ))
//                   ],
//                 ),
//               ))),
//     );
//   }
// }