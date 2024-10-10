import 'package:flutter/material.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/screen/infoscreen.dart';
import 'package:get/get.dart';
class FoodBody extends StatelessWidget {
  final int index;
  final List<String> hostlist;
  final String name;
  final List<String> foodlist; //food 클래스 선언
  final String foodtime;
  const FoodBody({
    required this.foodtime,
    required this.index,
    required this.name,
    required this.hostlist,
    required this.foodlist, //food 클래스 요구
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var foodstring =
        foodlist.toString().replaceAll('[', '').replaceAll(']', '');
    String price;
    switch (hostlist[index]) {
      case "별빛식당":
        price = "4900원";
        break;
      case "한빛식당":
        price = "5800원";
        break;
      case "은하수식당":
        price = "7000원";
        break;
      default:
        price = "";
        break;
    }
    price = ""; // 가격 임시 비활성화
    if(foodstring == "") foodstring = "${foodtime}에는 운영하지 않습니다.";
    return InkWell(
      //추후 컨테이너로 수정
      onTap: () {
        Get.toNamed('/foodscreen');
      },
      child: ListTile(
          title: Text("${hostlist[index]}"),
          titleTextStyle: mainfoodtitlestyle,
          subtitle: Text("${foodstring}",
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
          ),
          subtitleTextStyle: mainfoodstyle,
      ),
    );
  }
}

