import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ulife_final/const/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'package:ulife_final/listdata/classinfo.dart';

class SmallBody extends StatelessWidget {
  final Data data;
  SmallBody({
    required this.data,
    Key? key,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime dt = DateTime.parse(data.date.substring(0,10));
    Duration diff = now.difference(dt);

    String finaldate = DateFormat('yyyy.MM.dd').format(dt);
    if (diff.isNegative) {
      finaldate = "D${diff.inDays}";
    } 
    else if(data.host=="씨앗"||data.host=="대외활동"||data.host=="국비교육"||data.host=="공모전"){
      finaldate = "마감";
      }
    
    if(finaldate=="D0") finaldate = "D-DAY";
    return
      ListTile(
        onTap: () {
          _launchURL(data.url);
        },
        title: Text(
          "${data.title}",
          maxLines: 2,
          style: infolistcontentstyle,
        ),
        trailing: Text(
          "${finaldate}",
          style: infolistdatestyle,
        ),
      );
  }
}
