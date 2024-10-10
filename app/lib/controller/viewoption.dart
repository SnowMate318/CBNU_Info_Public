import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewOptionController extends GetxController {
  String viewoption = "전체";

  @override
  onInit(){

  }

  Future<void> initViewOption() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    viewoption = prefs.getString("defaultviewoption") ?? "전체";

    update();
  }

  setViewOption(String? selectedviewoption) {
    String tmp = selectedviewoption ?? "";
    viewoption = tmp == "" ? "전체" : tmp;
    update();
  }

  Future<void> viewOptionUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("defaultviewoption", viewoption);
  }
}
