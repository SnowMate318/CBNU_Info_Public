import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ntp/ntp.dart';
import 'package:ulife_final/controller/controller_user.dart';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:ulife_final/model/food/food.dart';
import 'package:ulife_final/const/defined_value.dart';
import 'package:ulife_final/strings.dart';

final APIKEY = API_KEY;

// {
//   "아침": [a,b,c],
//   "아점": [a,b,c],
//   "점심": [a,b,c],
//   "저녁": [a,b,c],

// }
Future<Map<String, List<Food>>> callAPIFood(String date, String host) async {
  MyInfo myInfo = Get.find();
  Map<String, List<Food>> newFoods = {
    FOOD_BREAKFIRST : [],
    FOOD_BLUNCH : [],
    FOOD_LUNCH : [],
    FOOD_DINNER : [],
  };
  var url = Uri.parse(
    'https://info.cbnu.ac.kr/api/meal/?search=${date}+${host}',
  );
  var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
    jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> datalist = jsonResponse["results"];
    for (int i=0;i<datalist.length;i++) {
      Food food = Food.fromMap(datalist[i]);
      String foodTime = food.foodTime;

      if(newFoods[foodTime] != null){
        newFoods[foodTime]!.add(food);
      }
    }
    for(String foodTime in FOOD_TIMES) {
      newFoods[foodTime] = newFoods[foodTime]!.toSet().toList();
    }

    return newFoods;

  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }


}
// {
//   "한빛식당": [a,b,c],
//   "별빛식당": [a,b,c],
//   "은하수식당": [a,b,c],
//   "양진재": [a,b,c],
//   "양성재": [a,b,c],
//   "본관": [a,b,c],
// }
Future<Map<String, List<Food>>> callAPIFoodMainScreen() async {
  MyInfo myInfo = Get.find();
  String finaldate = DateFormat('yyyy-MM-dd').format(await NTP.now());
  Map<String, List<Food>> foodSet = {
    CAFETERIA_HANBIT: [],
    CAFETERIA_BYEOLBIT: [],
    CAFETERIA_UNHASU: [],
    DORM_YANGJINJAE: [],
    DORM_YANGSEONGJAE: [],
    DORM_GAESEONGJAE:[],
  };
  var url = Uri.parse(
    'https://info.cbnu.ac.kr/api/meal/?search=${finaldate}',
  );
  var response = await http.get(url, headers: await myInfo.getFirebaseHeader());
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
    jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> datalist = jsonResponse["results"];
    for (int i=0;i<datalist.length;i++) {
      Food food = Food.fromMap(datalist[i]);
      String cafeteriaName = food.cafeteriaName;

      if(foodSet[cafeteriaName] != null){
        foodSet[cafeteriaName]!.add(food);
      }
    }

    for(String cafeteria in CAFETERIAS) {
      foodSet[cafeteria] = foodSet[cafeteria]!.toSet().toList();
    }
    return foodSet;
  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }
}


