import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ulife_final/controller/announcement.dart';
import 'package:get/get.dart';
import '../component/food_screen/food_view.dart';
import '../const/style.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/controller/tabview.dart';
import 'package:ulife_final/controller/tabviewitem.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    int index = args?["index"] ?? 0;
    TabviewItemController tabviewItemController = Get.find();
    FoodController foodController = Get.find();
    List<String> tabviewitems = tabviewItemController.getTabViewItems("오늘의 메뉴");
    tabviewItemController.title.value = "오늘의 메뉴";
    tabviewItemController.index.value = index;
    MyTabController tabController = Get.put(MyTabController());
    final TabController _tabController = tabController.controller;

    //foodController.setFood(tabviewitems[index], DateTime.now().toString());

    List<Widget> hostWidgets = tabviewitems.map((String tabText) {
      return Container(child: Tab(text: tabText));
    }).toList();

    List<Widget> infoBlockWidgets = tabviewitems.map((String tabText) {
      return FoodInfoBlock(host: tabText);
    }).toList();

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
        title: const Text("식당정보"),
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

      //endDrawer: DrawerWidget(),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: infoBlockWidgets,
        ),
      ),
    );
  }
}

class FoodInfoBlock extends StatefulWidget {
  String host;

  FoodInfoBlock({Key? key, required this.host}) : super(key: key);

  @override
  State<FoodInfoBlock> createState() => _FoodInfoBlockState();
}

class _FoodInfoBlockState extends State<FoodInfoBlock> {
  late FoodController foodController;

  List<String> timelist = ["아침", "아침", "점심", "저녁"];

  @override
  void didChangeDependencies() async {
    setState(() {
      foodController = Get.find();
    });
    await foodController.setFood(widget.host, foodController.finaldate.value);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 24.0,
              ),
              onPressed: () {
                foodController.changeDate(false, widget.host);
              },
            ),
            Obx(() {
              return Text(
                  "${foodController.date.year}년 ${foodController.date.month}월 ${foodController.date.day}일(${foodController.krday})",
                  style: fooddatestyle);
            }),
            IconButton(
              icon: const Icon(Icons.arrow_forward, size: 24.0),
              onPressed: () {
                foodController.changeDate(true, widget.host);
              },
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: ListView.builder(
            itemCount: timelist.length,
            itemBuilder: (context, index) {
              return FoodView(
                title: timelist[index],
                index: index,
                host: widget.host,
                day: foodController.day.value,
              );
            },
          ),
        ))
      ],
    );
  }
}

// Widget foodInfoBlock(BuildContext context, String host) {
//   List<String> timelist = ["아침", "아점", "점심", "저녁"];
//   return SizedBox(child: GetBuilder<FoodController>(
//     builder: (controller) {
//       var finaldate = controller.finaldate;
//       var date = controller.date;
//       var krday = controller.krday;
//
//       controller.setFood(host,finaldate.value);
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//
//                 onPressed: () {
//                   controller.changeDate(false, host);
//                 },
//
//               ),
//               Text("${date.year}년 ${date.month}월 ${date.day}일(${krday})",
//                   style: fooddatestyle),
//               IconButton(
//                 icon: Icon(Icons.arrow_forward),
//
//                 onPressed: () {
//                   controller.changeDate(true, host);
//                 },
//
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           Expanded(
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height - 80,
//                 child: ListView.builder(
//                   itemCount: timelist.length,
//                   itemBuilder: (context, index) {
//                     return FoodView(
//                       title: timelist[index],
//                       index: index,
//                       host: host,
//                       day: controller.day.value,
//                     );
//                   },
//                 ),
//               ))
//         ],
//       );
//     },
//   ));
// }

// class FoodInfoBlock extends StatelessWidget {
//   final String host;
//   const FoodInfoBlock({required this.host, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> timelist = ["아침", "아점", "점심", "저녁"];
//     return SizedBox(child: GetBuilder<FoodController>(
//       builder: (controller) {
//         var finaldate = controller.finaldate;
//         var date = controller.date;
//         var krday = controller.krday;
//         print("여기냐?");
//         controller.setFood(host,finaldate.value);
//         return Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back),
//
//                   onPressed: () {
//                     controller.changeDate(false, host);
//                   },
//
//                 ),
//                 Text("${date.year}년 ${date.month}월 ${date.day}일(${krday})",
//                     style: fooddatestyle),
//                 IconButton(
//                   icon: Icon(Icons.arrow_forward),
//
//                   onPressed: () {
//                     controller.changeDate(true, host);
//                   },
//
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 24,
//             ),
//             Expanded(
//                 child: SizedBox(
//               height: MediaQuery.of(context).size.height - 80,
//               child: ListView.builder(
//                 itemCount: timelist.length,
//                 itemBuilder: (context, index) {
//                   return FoodView(
//                     title: timelist[index],
//                     index: index,
//                     host: host,
//                     day: controller.day.value,
//                   );
//                 },
//               ),
//             ))
//           ],
//         );
//       },
//     ));
//   }
// }
