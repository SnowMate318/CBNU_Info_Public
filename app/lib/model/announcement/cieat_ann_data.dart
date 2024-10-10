import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:ulife_final/strings.dart';
import 'package:ulife_final/model/announcement/cieat_ann.dart';
import 'package:ulife_final/const/defined_value.dart';
final APIKEY = API_KEY;

Future<List<CieatAnn>> getCieatAnnFromDatabase(String viewoption, int page, int? num) async {
  List<CieatAnn> cieatsMain = [];
  String urlstr;

  switch (viewoption) {
    case DURATION_WEEK:
      urlstr = "https://info.cbnu.ac.kr/api/cieat/week/?page=$page";
      break;
    case DURATION_MONTH:
      urlstr = "https://info.cbnu.ac.kr/api/cieat/month/?page=$page";
      break;
    default:
      urlstr = "https://info.cbnu.ac.kr/api/cieat/?page=$page";
      break;
  }
  var url = Uri.parse(urlstr);
  var response = await http.get(url, headers: {
    HttpHeaders.authorizationHeader: APIKEY,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
    jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> datalist = jsonResponse["results"];

    if (num != null) {
      cieatsMain.clear();
      int listlength = datalist.length >= num ? num : datalist.length;
      for (int i = 0; i < listlength; i++) {
        cieatsMain.add(
          CieatAnn.fromMap(datalist[i])
        );
      }
    }
    return cieatsMain;
  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }
}