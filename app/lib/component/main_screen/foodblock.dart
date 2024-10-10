import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/component/main_screen/smallhead.dart';
import 'package:ulife_final/component/main_screen/foodbody.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/listdata/classinfo.dart';
import 'package:ulife_final/controller/viewoption.dart';
import 'package:ulife_final/controller/mainscreencontroller.dart';


class FoodBlock extends StatelessWidget {

  final String title;
  final List<Food> datalist;
  final List<String> hostlist;
  const FoodBlock({
    required this.hostlist,
    required this.title,
    required this.datalist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainScreenController mainScreenController = Get.find();
    Map<String,List<String>>foodlistMap = {};
    DateTime ft = DateTime.now();
    int hour = ft.hour;
    late String tmp;

    if(hour<10) {
      tmp = "아침";
    }
    else if(hour<14) tmp = "점심";
    else tmp = "저녁";

      for(String str in hostlist){
        foodlistMap[str] = [];
        for(Food data in datalist){
          if(tmp=="아침"&&data.foodtime=="아점"&&data.cafeterianame=="한빛식당"&&str=="한빛식당"){
            foodlistMap["한빛식당"]!.add(data.foodname);
          }
          else if(data.foodtime==tmp&&data.cafeterianame==str)foodlistMap[str]!.add(data.foodname);
          
        }
      }

    return Obx((){

      return mainScreenController.selectlist["오늘의 메뉴"]!?Column(
      children: [
        const SizedBox(height: 24),
        SmallHead(
          name: title,
        ),
        Container(
          //padding: EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              color: WHITE_COLOR,
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          height: hostlist.length * 72 + 4,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hostlist.length,
            itemBuilder: (context, index) {
              return FoodBody(
                index: index,
                hostlist: hostlist,
                name: title,
                foodlist: foodlistMap[hostlist[index]]??[],
                foodtime: tmp,
              );
            },
            separatorBuilder: (BuildContext context, int index) { return const Divider(thickness: 1, height: 1); },
          ),
        ),
        const SizedBox(height: 48),
      ],
    ):SizedBox();
    });
    
    
    
  }
}
