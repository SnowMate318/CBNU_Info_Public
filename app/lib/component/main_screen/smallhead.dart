import 'package:flutter/material.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:get/get.dart';
import 'package:ulife_final/controller/update.dart';

class SmallHead extends StatelessWidget {
  final String name;
  final List<String>? hostlist;
  SmallHead({
    required this.name,
    this.hostlist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: WHITE_COLOR,
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${name}",
                  style: mediumtitlestyle),
              TextButton(
                  onPressed: () {
                    if(name=="오늘의 메뉴") Get.toNamed('/food');
                    else {
                      Get.toNamed('/informations',
                          arguments: {"title": name, "hostlist": hostlist});
                    }
                    //Get.delete<MainScreenController>();
                  },
                  child: Text("더 보기",
                      style: bluetextstyle))
            ],
          )),
    );
  }
}
