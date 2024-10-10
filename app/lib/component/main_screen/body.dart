import 'package:flutter/material.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:intl/intl.dart';
import 'package:ulife_final/const/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

class Body extends StatelessWidget {
  final String host;
  final String title;
  final dynamic date; // 추후 형식에 맞게 수정
  String? url;

  Body({
    required this.host,
    required this.title,
    required this.date,
    this.url,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime dt = DateTime.parse(date);
    Duration diff = now.difference(dt);

    String finaldate = DateFormat('M/d').format(dt);
    if (diff.isNegative) {
      finaldate = "D${diff.inDays}";
      if (finaldate == "D0") {
        finaldate = "D-Day";
      }
    } else if (host == "씨앗" ||
        host == "대외활동" ||
        host == "국비지원" ||
        host == "공모전") {
      finaldate = "마감";
    } // 추가

    void _launchURL(String? url) async {
      String finalURL = url ?? "";
      if (await canLaunch(finalURL) && finalURL != "") {
        await launch(finalURL);
      } else if (finalURL == "") {
        print("URL NOT REFLECTED");
      } else {
        throw 'Could not launch $finalURL';
      }
    }

    return InkWell(
      onTap: () {
        _launchURL(url);
      },
      child: ListTile(
        title: Text(
          host,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
        ),
        titleTextStyle: listtitlestyle,
        subtitle: Text(
          title,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
        ),
        subtitleTextStyle: listcontentstyle,
        trailing: Text(finaldate),
        leadingAndTrailingTextStyle: listdatestyle,
      ),
    );
  }
}

// Widget a(host,finaldate,title){
//   return
// }
