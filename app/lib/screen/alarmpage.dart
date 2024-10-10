import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/controller_user.dart';
import '../analytics.dart';
import '../controller/controller_keyword.dart';

// StatefulWidget으로 변경
class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

// State 클래스 추가
class _AlarmPageState extends State<AlarmPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController keywordFormController;
  String keyword = "";
  late MyInfo myInfo;
  late String fcmToken;
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    keywordFormController = TextEditingController();
    myInfo = Get.find();
    fcmToken = myInfo.infoUser.fcmToken;
    debugPrint(fcmToken);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    KeywordController keywordController = Get.find();
    user = FirebaseAuth.instance.currentUser!;
    await keywordController.fetchKeyword();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    keywordFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GetX 컨트롤러 인스턴스 가져오기
    KeywordController keywordController = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "키워드 알림 설정",
          style: alarmMainTitleStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: WHITE_COLOR,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text(
                        "키워드 알림",
                        style: alarmTitleStyle,
                      ),
                      subtitle: Obx(() {
                        return Text(
                          "알림 받을 키워드 (${keywordController.keywordNum}/20)",
                          style: alarmSubTitleStyle,
                        );
                      }),
                    ),
                    const SizedBox(height: 4.0),
                    Form(
                      key: _formKey,
                      child: ListTile(
                        title: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "키워드를 입력하세요. (예: 장학금)",
                          ),
                          controller: keywordFormController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '키워드를 입력해주세요. ';
                            }
                            if (value.length > 30) {
                              return '키워드는 최대 30자까지 입력 가능합니다. ';
                            }
                            if (keywordController.keywordNum >= 20) {
                              return '키워드는 최대 20개까지 입력 가능합니다. ';
                            }
                            if (keywordController.keywordList.contains(value)) {
                              return '동일한 키워드가 이미 존재합니다. ';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              keyword = value;
                            });
                          },
                        ),
                        trailing: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              )),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (keywordController.keywordList.length < 20) {
                                MyInfo myInfo = Get.find();
                                await keywordController.addKeyword(
                                    myInfo.user!, keyword);
                                keywordFormController.text = "";
                                await handleKeywords(keyword); // 구글 애널리틱스
                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content:
                                        const Text("키워드는 최대 20개까지 등록할 수 있습니다"),
                                        actions: [
                                          Center(
                                            child: TextButton(
                                                child: const Text("확인"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          )
                                        ],
                                      );
                                    });
                              }
                            } else {
                              debugPrint("validation 오류");
                              debugPrint("폼 키 현재상태: 유효하지 않음");
                            }
                          },
                          child: const Text("등록"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                          child: Obx(() {
                            return Wrap(
                              spacing: 8.0,
                              children: List<Widget>.generate(
                                keywordController.keywordList.length,
                                    (int index) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: InputChip(
                                        label: Text(
                                            keywordController.keywordList[index]),
                                        onDeleted: () async {
                                          MyInfo myInfo = Get.find();
                                          await keywordController.deleteKeyword(
                                              myInfo.user!, index);
                                        }),
                                  );
                                },
                              ).toList(),
                            );
                          }),
                        )
                  ],
                )

              )
            ],
          ),
        ),
      ),
    );
  }
}
