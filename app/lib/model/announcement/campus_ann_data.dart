import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:ulife_final/strings.dart';
import 'package:ulife_final/model/announcement/campus_ann.dart';
import 'package:ulife_final/const/defined_value.dart';
final APIKEY = API_KEY;


Future<List<CampusAnn>> getCampusAnnFromDatabase(
    String major, String viewoption, int page, int num) async {
  List<CampusAnn> campusAnnouncementsMain = [];
  String urlstr; // 요청 url을 변수로 저장
  switch (viewoption) {
    case DURATION_WEEK:
      urlstr =
      "https://info.cbnu.ac.kr/api/announcement/week/?search=${major}&page=$page";
      break;
    case DURATION_MONTH:
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
  var response = await http.get(url, headers: {
    HttpHeaders.authorizationHeader: APIKEY,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
    jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> datalist = jsonResponse["results"];

    int listlength = datalist.length >= num ? num : datalist.length;
    //db에 남은 데이터 수가 num보다 작으면 그 수만큼, num보다 크거나 같으면 num 갯수만큼 가져욤
    for (int i = 0; i < listlength; i++) {
      campusAnnouncementsMain.add(
          CampusAnn.fromMap(datalist[i])
      );
    }

    return campusAnnouncementsMain;

  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }
}