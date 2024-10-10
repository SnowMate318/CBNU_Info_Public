import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulife_final/controller/announcement.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/update.dart';
import 'package:ulife_final/controller/viewoption.dart';
import 'package:ulife_final/listdata/classinfo.dart';

import 'controller_user.dart';

class MainScreenController extends GetxController {
  var selectlist = <String, bool>{}.obs;
  RxBool switchValue = false.obs;
  var selectedData = <String,dynamic>{}.obs;
  var isInitialized = true.obs;
  RxSet<Data> tmp = <Data>{}.obs;
  CampusAnnController campusAnnController = Get.find();
  ExtracurAnnController extracurAnnController = Get.find();
  MainScreenFoodController mainScreenFoodController = Get.find();
  CieatController cieatController = Get.find();
  TabviewItemController tabviewItemController = Get.find();
  ViewOptionController viewOptionController = Get.find();
  MyInfo myInfo = Get.find();
  @override
  void onInit() {
    super.onInit();
    refresh();
  }



  void refresh()async{
    isInitialized.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    selectlist["교내 활동"] = prefs.getBool("innerSelected") ?? true;
    selectlist["교외 활동"] = prefs.getBool("outerSelected") ?? true;
    selectlist["오늘의 메뉴"] = prefs.getBool("mealSelected") ?? true;
    await myInfo.fetch();
    await tabviewItemController.initMajor();
    await tabviewItemController.initDorm();
    await viewOptionController.initViewOption();
    String viewoption = viewOptionController.viewoption;
    List<String> majors = tabviewItemController.majors.toList();
    List<String> dorms = tabviewItemController.dorms.toList();
    MyScrollController myScrollController = Get.find();
    int num = 6;
    campusAnnController.clearMainSet();
    if(majors.length>=2){
       
      await campusAnnController.updateCampusAnnouncement(majors[0], viewoption, 2);
      await campusAnnController.updateCampusAnnouncement(majors[1], viewoption, 1);
    } else if(majors.length==1){
      await campusAnnController.updateCampusAnnouncement(majors[0], viewoption, 3);
    }
    if(dorms.isNotEmpty){
      await campusAnnController.updateCampusAnnouncement("기숙사",viewoption, 1);
    }
    if(campusAnnController.campusAnnouncementsMain.length<=1){
      await campusAnnController.updateCampusAnnouncement("충북대학교",viewoption, 2);
    } else {
      await campusAnnController.updateCampusAnnouncement("충북대학교",viewoption, 1);
    }
    await cieatController.updateCieat(viewoption, num-campusAnnController.campusAnnouncementsMain.length);

    await extracurAnnController.updateExternalAnnouncement(viewoption, 4, null);
    await extracurAnnController.updateExternalAnnouncement(viewoption, null, "국비교육");
    await extracurAnnController.updateExternalAnnouncement(viewoption, null, "대외활동");
    await extracurAnnController.updateExternalAnnouncement(viewoption, null, "공모전");
    
    await mainScreenFoodController.addFoodMainScreen("한빛식당");
    await mainScreenFoodController.addFoodMainScreen("별빛식당");
    await mainScreenFoodController.addFoodMainScreen("은하수식당");
    for (String dorm in dorms) {
      await mainScreenFoodController.addFoodMainScreen(dorm);
    }

    tmp.clear();
    tmp.addAll(campusAnnController.campusAnnouncementsMain);
    tmp.addAll(cieatController.cieatsMain);
    selectedData["교내 활동"] = tmp.toList();
    selectedData["교외 활동"] = extracurAnnController.externalAnnouncementsMain.toList();
    selectedData["오늘의 메뉴"] = mainScreenFoodController.mainscreenfoods.toList();

    isInitialized.value = false;
  }

  void updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void toggleSwitch(String title, bool value) {
    selectlist[title] = value;

    String prefKey;
    switch (title) {
      case "교내 활동":
        prefKey = "innerSelected";
        break;
      case "교외 활동":
        prefKey = "outerSelected";
        break;
      case "오늘의 메뉴":
        prefKey = "mealSelected";
        break;
      default:
        prefKey = "";
    }

    if (prefKey.isNotEmpty) {
      updatePreference(prefKey, value);
      selectlist[prefKey]=value;
    }
  } 
}
