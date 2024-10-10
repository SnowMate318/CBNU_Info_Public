import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/component/main_screen/body.dart';
import 'package:ulife_final/component/main_screen/smallhead.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/listdata/classinfo.dart';
import 'package:ulife_final/controller/mainscreencontroller.dart';
class Block extends StatelessWidget {
  final String title;
  final List<Data> datalist;
  final String viewoption;
  const Block({
    required this.title,
    required this.datalist,
    required this.viewoption,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainScreenController mainScreenController = Get.find();
    return Obx((){
      return mainScreenController.selectlist[title]!?Column(children: [
      const SizedBox(height: 24),
      SmallHead(name: title),
      //const Divider(),
      Container(
        //padding: EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
            color: WHITE_COLOR,
           borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        height: datalist.length * 72+4,
        child: ListView.separated(

          physics: const NeverScrollableScrollPhysics(),
          itemCount: datalist.length,

          itemBuilder: (context, index) {
            return Body(
                host: datalist[index].host,
                title: datalist[index].title,
                date: datalist[index].date, //여기서
                url: datalist[index].url);
          },
        separatorBuilder: (BuildContext context, int index) { return const Divider(thickness: 1, height: 1); },
        ),
      ),
      const SizedBox(height: 4.0),

    ]):SizedBox();
    });
}

}