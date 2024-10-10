import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:ulife_final/strings.dart';
import 'package:ulife_final/model/announcement/external_ann.dart';
import 'package:ulife_final/const/defined_value.dart';
final APIKEY = API_KEY;


Future<List<ExternalAnn>> getExternalAnnFromDatabase(String viewoption, int page, int num) async {
  List<ExternalAnn> externalAnnouncementsMain = [];
  String urlstr;

  switch (viewoption) {
    case DURATION_WEEK:
      urlstr = "https://info.cbnu.ac.kr/api/extracur/week/?page=$page";
      break;
    case DURATION_MONTH:
      urlstr = "https://info.cbnu.ac.kr/api/extracur/month/?page=$page";
      break;
    default:
      urlstr = "https://info.cbnu.ac.kr/api/extracur/?page=$page";
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
    for (int i = 0; i < listlength; i++) {
      externalAnnouncementsMain.add(
        ExternalAnn.fromMap(datalist[i])
      );
    }

    return externalAnnouncementsMain;
  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }
}

Future<List<ExternalAnn>> getSearchedExternalAnnFromDatabase(String host, String viewoption, int page, int num) async {
  List<ExternalAnn> externalAnnouncementsMain = [];
  String urlstr;
  switch (viewoption) {
    case DURATION_WEEK:
      urlstr = "https://info.cbnu.ac.kr/api/extracur/week/?page=$page&search=$host";
      break;
    case DURATION_MONTH:
      urlstr = "https://info.cbnu.ac.kr/api/extracur/month/?page=$page&search=$host";
      break;
    default:
      urlstr = "https://info.cbnu.ac.kr/api/extracur/?page=$page&search=$host";
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
    for (int i = 0; i < listlength; i++) {
      externalAnnouncementsMain.add(
          ExternalAnn.fromMap(datalist[i])
      );
    }

    return externalAnnouncementsMain;
  } else {
    throw Exception(
        'HTTP request failed with status: ${response.statusCode}');
  }
}