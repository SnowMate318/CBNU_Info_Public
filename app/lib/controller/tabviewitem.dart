import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabviewItemController extends GetxController {
  
  Set<String> defaultset = {"씨앗", "충북대학교"};
  Set<String> defaultfoodset = {"한빛식당", "별빛식당", "은하수식당"};
  RxSet<String> majors = <String>{}.obs;
  RxSet<String> dorms = <String>{}.obs;
  var index = 0.obs;
  var title = "교내 활동".obs;

  Future<void> initMajor() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    majors.clear();
    Set<String> tmp = ((prefs.getStringList("defaultmajorlist"))??[]).toSet();
    majors.addAll(tmp);
  }

  void setMajor (Set<String> selectedmajors){
    majors.clear();
    majors.addAll(selectedmajors);
  }
  
  Future<void> updateMajor() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("defaultmajorlist", majors.toList());
  }

  Future<void> initDorm() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dorms.clear();
    Set<String> tmp = (prefs.getStringList("defaultdormlist") ?? []).toSet();
    dorms.addAll(tmp);
  }


  void setDorm (Set<String> selecteddorms){
    dorms.clear();
    dorms.addAll(selecteddorms);
  }

  Future<void> updateDorm() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("defaultdormlist", dorms.toList());
  }

  
  List<String> getMainCampusActivationList(){
    Set<String> returnitems = {};
    returnitems.addAll(majors);
    if(dorms.isNotEmpty) returnitems.add("기숙사");
    returnitems.addAll(defaultset);
    return returnitems.toList();
   }

    List<String> getExternalActivationList(){
      return ["공모전", "대외활동", "국비교육"];
    }

    List<String> getMainCafeteriaList(){
    Set<String> returnItems = {};
    returnItems.addAll(defaultfoodset);
    returnItems.addAll(dorms);
    return returnItems.toList();
    }

    List<String> getTabViewItems(String title){
    late List<String> tmp;
    switch(title){
      case "교내 활동":
        tmp = getMainCampusActivationList();
        break;
      case "교외 활동":
        tmp = getExternalActivationList();
        break;
      default: 
        tmp = getMainCafeteriaList();
        break;
    }
      return tmp;
    }



    String getMajorString(){
      return majors.join(', ');
    }
    String getDormString(){
      return dorms.join(', ');
    }
}