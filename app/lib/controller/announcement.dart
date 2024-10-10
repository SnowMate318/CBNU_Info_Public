import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ulife_final/controller/controller_user.dart';
import 'dart:convert';
import 'dart:io';
import 'package:ulife_final/listdata/classinfo.dart';
import '../strings.dart';


class CampusAnnController extends GetxController {

  MyInfo myInfo = Get.find();
  Set<Data> campusAnnouncementsMain = {};
  RxMap<String, Set<Data>> CampusData = <String, Set<Data>>{}.obs;
  RxMap<String, int> CampusPage = <String, int>{}.obs;
  RxMap<String, bool> CampusHasData = <String, bool>{}.obs;


  void clearMainSet(){
    campusAnnouncementsMain.clear();
    update();
  }
  Future<void> updateCampusAnnouncement(
      String major, String viewoption, int? num) async {
    try {
      if(CampusPage[major]==null){
        CampusPage[major] = 1;
        CampusHasData[major] = true;
        CampusData[major] = {};
      }
      int currentPage = CampusPage[major]!;
      if(CampusHasData[major]!){
        await callAPIann(major, viewoption, currentPage, num);
      }
      CampusPage[major] = currentPage+1;
    } catch (e) {
      print('Error fetching announcements: $e');
    }

    update(); // Notify the listeners
  }

  Future<void> callAPIann(
      String major, String viewoption, int page, int? num) async {
    String urlstr; // 요청 url을 변수로 저장
    switch (viewoption) {
      case "최근 1주일":
        urlstr =
            "https://info.cbnu.ac.kr/api/announcement/week/?search=${major}&page=$page";
        break;
      case "최근 1달":
        urlstr =
            "https://info.cbnu.ac.kr/api/announcement/month/?search=${major}&page=$page";
        break;
      default:
        urlstr =
            "https://info.cbnu.ac.kr/api/announcement/?search=${major}&page=$page";
        break;
    }
    var url = Uri.parse(
      urlstr,
    );
    var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> datalist = jsonResponse["results"];

      if (num != null) {
        int listlength = datalist.length >= num ? num : datalist.length;

        for (int i = 0; i < listlength; i++) {
          campusAnnouncementsMain.add(Data(
            host: datalist[i]['major'],
            title: datalist[i]['title'],
            date: datalist[i]['date_post'],
            url: datalist[i]['url'],
          ));
        }
      }
      Set<Data> newData = {};
      for (dynamic dyn in datalist) {
        newData.add(Data(
          host: dyn['major'],
          title: dyn['title'],
          date: dyn['date_post'],
          url: dyn['url'],));
      }
      CampusData[major]!.addAll(newData);
      if(newData.length<30){
        CampusHasData[major]=false;
      }
    } else {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
  }
}

class ExtracurAnnController extends GetxController {
  MyInfo myInfo = Get.find();
  Set<Data> externalAnnouncementsMain = {};
  RxMap<String, Set<Data>> ExtData = <String, Set<Data>>{}.obs;
  RxMap<String, int> ExtPage = <String, int>{}.obs;
  RxMap<String, bool> ExtHasData = <String, bool>{}.obs;

  Future<void> updateExternalAnnouncement(
      String viewoption, int? num, String? host) async {
    try {
      if(host!=null){
        if(ExtPage[host] == null){
          ExtPage[host] = 1;
          ExtHasData[host] = true;
          ExtData[host] = {};
        }
        int currentPage = ExtPage[host]!;
        await callAPIext(viewoption, currentPage, num, host);

        ExtPage[host] = currentPage+1;

      } else {
        await callAPIext(viewoption, 1, num, null);
        update();
      }
    } catch (e) {
      print('Error fetching announcements: $e');
    }
    // Notify the listeners
  }

  Future<void> callAPIext(String viewoption, int page, int? num, String? host) async {
    String urlstr;
    if(host==null){
      switch (viewoption) {
        case "최근 1주일":
          urlstr = "https://info.cbnu.ac.kr/api/extracur/week/?page=$page";
          break;
        case "최근 1달":
          urlstr = "https://info.cbnu.ac.kr/api/extracur/month/?page=$page";
          break;
        default:
          urlstr = "https://info.cbnu.ac.kr/api/extracur/?page=$page";
          break;
      }
    }else{
      switch (viewoption) {
        case "최근 1주일":
          urlstr = "https://info.cbnu.ac.kr/api/extracur/week/?page=$page&search=$host";
          break;
        case "최근 1달":
          urlstr = "https://info.cbnu.ac.kr/api/extracur/month/?page=$page&search=$host";
          break;
        default:
          urlstr = "https://info.cbnu.ac.kr/api/extracur/?page=$page&search=$host";
          break;
      }
    }
    var url = Uri.parse(
      urlstr,
    );
    var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> datalist = jsonResponse["results"];
      if (num != null) {
        externalAnnouncementsMain.clear();
        for (int i = 0; i < num; i++) {
          externalAnnouncementsMain.add(Data(
            host: datalist[i]['category'],
            title: datalist[i]['title'],
            date: datalist[i]['closingdate'],
            url: datalist[i]['url'],
          ));
        }
      } else {
        if(host != null) {
          Set<Data> newData = {};
          for (dynamic dyn in datalist) {
            newData.add(Data(
              host: dyn['category'],
              title: dyn['title'],
              date: dyn['closingdate'],
              url: dyn['url'],
            ));
            ExtData[host]!.addAll(newData);
            if(newData.length<30){
              ExtHasData[host] = false;
            }
        }
      }



    }
    } else {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
  }
}

class CieatController extends GetxController {
  MyInfo myInfo = Get.find();
  Set<Data> cieatsMain = {};
  RxMap<String, Set<Data>> ExtData = <String, Set<Data>>{}.obs;
  RxInt page = 1.obs;
  RxBool hasData = true.obs;
  RxSet<Data> data = <Data>{}.obs;

  Future<void> updateCieat(String viewoption, int? num) async {
    try{
      int currentPage = page.value;
      if(hasData.value){
        await callAPIcieat(viewoption, currentPage, num);
      }
      page.value = currentPage+1;
    } catch (e) {
      print('Error fetching announcements: $e');
    }
    update(); // Notify the listeners
  }

  Future<void> callAPIcieat(String viewoption, int page, int? num) async {
    String urlstr;
    switch (viewoption) {
      case "최근 1주일":
        urlstr = "https://info.cbnu.ac.kr/api/cieat/week/?page=$page";
        break;
      case "최근 1달":
        urlstr = "https://info.cbnu.ac.kr/api/cieat/month/?page=$page";
        break;
      default:
        urlstr = "https://info.cbnu.ac.kr/api/cieat/?page=$page";
        break;
    }
    var url = Uri.parse(urlstr);
    var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> datalist = jsonResponse["results"];

      if (num != null) {
        cieatsMain.clear();
        int listlength = datalist.length >= num ? num : datalist.length;
        for (int i = 0; i < listlength; i++) {
          cieatsMain.add(Data(
            host: "씨앗",
            title: datalist[i]['title'],
            date: datalist[i]['recruit_time_close'],
            url: datalist[i]['url'],
          ));
        }

      }
      Set<Data> newData = {};
      for (dynamic dyn in datalist) {
        newData.add(Data(
          host:"씨앗",
          title: dyn['title'],
          date: dyn['recruit_time_close'],
          url: dyn['url'],
        ));
      }
      data.addAll(newData);
      if(newData.length<30){
        hasData.value = false;
      }
    } else {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
  }
}

class MainScreenFoodController extends GetxController {
  MyInfo myInfo = Get.find();
  Set<Food> mainscreenfoods = {};
  Future<void> addFoodMainScreen(String host) async {
    try {
      Set<Food> tmp = await callAPIFoodMainScreen(host);
      mainscreenfoods.addAll(tmp);
    } catch (e) {
      print('Error fetching announcements: $e');
    }
    update(); // Notify the listeners
  }

  List<Food> getMainScreenFoods(String host) {
    return mainscreenfoods.toList();
  }

  Future<Set<Food>> callAPIFoodMainScreen(String host) async {
    String finaldate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var url = Uri.parse(
      'https://info.cbnu.ac.kr/api/meal/?search=${finaldate}+${host}',
    );
    var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      Set<Food> foodSet = {};

      for (var k in jsonResponse) {
        foodSet.add(Food(
          menudate: k["menu_date"],
          foodtime: k["food_time"],
          cafeterianame: k["cafeteria_name"],
          foodname: k["food_name"],
        ));
      }
      return foodSet;
    } else {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }
  }
}

class FoodController extends GetxController {
  MyInfo myInfo = Get.find();
  Set<List<Food>> foods = {};
  RxList<Set<String>> mealbytime = <Set<String>>[{},{},{},{}].obs;

  DateTime date = DateTime.now();
  RxString finaldate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  RxString day = "Mon".obs;
  RxString krday = "월".obs;

  @override
  void onInit() async {
    await setFood(finaldate.value, "한빛식당");
    day.value = DateFormat('E').format(DateTime.now()).toString();
    krday.value = getKRDay();
    super.onInit();
  }
  void changeDate(bool plus, String host) {
    if (plus){
      date = date.add(Duration(days: 1));
    }
    else{
      date = date.subtract(Duration(days: 1));
    }
    update();
    day.value = DateFormat('E').format(date).toString();
    krday.value = getKRDay();
    finaldate.value = DateFormat('yyyy-MM-dd').format(date);
    setFood(finaldate.value, host);
  }

  String getKRDay(){
    String tmp = "월";
      switch (day.value) {
      case "Mon":
        tmp = "월";
        break;
      case "Tue":
        tmp = "화";
        break;
      case "Wed":
        tmp = "수";
        break;
      case "Thu":
       tmp = "목";
        break;
      case "Fri":
        tmp = "금";
        break;
      case "Sat":
        tmp = "토";
        break;
      case "Sun":
        tmp = "일";
        break;
    }
    return tmp;
  }

  void setFoodString() {
    int foodidx = 0;
    for (List<Food> food in foods) {
      Set<String> tmp = {};
      for (Food fooddata in food) {
        tmp.add(fooddata.foodname);
      }
      mealbytime[foodidx] = tmp;
      foodidx++;
    }
  }

  Future<void> setFood(String host, String date) async {
    try {
      foods = await callAPIFood(host, date);
      setFoodString();
      update();
    } catch (e) {
      print('Error fetching announcements: $e');
    }
  }

  Future<Set<List<Food>>> callAPIFood(String host, String date) async {
    Set<List<Food>> newFoods = {[], [], [], []};
    List<Food> newFoodList = [];
    var url = Uri.parse(
      'https://info.cbnu.ac.kr/api/meal/?search=${date}+${host}',
    );
    var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      for (var k in jsonResponse) {
        newFoodList.add(Food(
          menudate: k["menu_date"],
          foodtime: k["food_time"],
          cafeterianame: k["cafeteria_name"],
          foodname: k["food_name"],
        ));
      }

      for (var foodItem in newFoodList) {
        if (foodItem.foodtime == "아침")
          newFoods.elementAt(0).add(foodItem);
        else if (foodItem.foodtime == "아점")
          newFoods.elementAt(1).add(foodItem);
        else if (foodItem.foodtime == "점심")
          newFoods.elementAt(2).add(foodItem);
        else
          newFoods.elementAt(3).add(foodItem);
      }
    } else {
      throw Exception(
          'HTTP request failed with status: ${response.statusCode}');
    }

    return newFoods;
  }
}
