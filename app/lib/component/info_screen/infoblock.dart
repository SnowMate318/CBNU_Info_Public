import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/component/info_screen/smallbody.dart';
import 'package:ulife_final/controller/update.dart';
import '../../const/colors.dart';
import '../../const/style.dart';
import '../../controller/announcement.dart';
import '../../listdata/classinfo.dart';

class InfoBlock extends StatelessWidget {
  final String headtitle;
  final String host;
  String viewoption;

  InfoBlock({
    required this.headtitle,
    required this.host,
    required this.viewoption,
    Key? key,
  }) : super(key: key);

  late String finaldate;
  CieatController cieatController = Get.find();
  CampusAnnController campusAnnController = Get.find();
  ExtracurAnnController extracurAnnController = Get.find();
  MyScrollController infoUpdateController = Get.find();
  late Set<Data> currentData;
  @override
  Widget build(BuildContext context) {
    // infoUpdateController.refresh();
    infoUpdateController.refreshController(host, viewoption);
    // API 호출
    return Obx(() {
      switch (host) {
        case "씨앗":
          currentData = cieatController.data;
          break;
        case "대외활동":
        case "국비교육":
        case "공모전":
          currentData = extracurAnnController.ExtData[host] ?? {};
          break;
        default:
          currentData = campusAnnController.CampusData[host] ?? {};
          break;
      }
      if (infoUpdateController.isMoreRequesting.value && currentData.isEmpty) {
        // 로딩 중
        return Container(
          color: WHITE_COLOR,
          child: const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          ),
        );
      }
      if (!infoUpdateController.isMoreRequesting.value && currentData.isEmpty) {
        // 데이터가 없는 경우
        return Container(
          color: WHITE_COLOR,
          child: const Center(
            child: Text(
              "조건에 맞는 공지가 없습니다.",
              style: emptystyle,
            ),
          ),
        );
      }
      return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          color: WHITE_COLOR,
          height: MediaQuery.of(context).size.height - 90,
          child: ListView.separated(
            controller: infoUpdateController.scrollController.value,
            separatorBuilder: (_, index) => Divider(),
            itemCount: currentData.length + 1,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              if (index < currentData.length) {
                return SmallBody(
                  data: currentData.toList()[index],
                );
              } else {
                if (infoUpdateController.isMoreRequesting.value) {
                  return Center(child: RefreshProgressIndicator());
                } else {
                  return SizedBox();
                }
              }
            },
          ),
        ),
      );
    });
  }
}
