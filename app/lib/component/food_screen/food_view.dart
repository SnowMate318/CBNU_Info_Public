import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/announcement.dart';
import 'package:ulife_final/const/food_time.dart';
class FoodView extends StatelessWidget {
  final String title;
  final String host;
  final String day;
  final int index;
  const FoodView({
    required this.host,
    required this.title,
    required this.day,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FoodController foodController = Get.find();
    String finaltitle = title;

    switch (host) {
      case "한빛식당":
        switch (title) {
          case "점심":
            finaltitle = finaltitle + HANBIT_LUNCH_TIME;
            break;
          case "저녁":
            finaltitle = finaltitle + HANBIT_DINNER_TIME;
            break;
          default:
            finaltitle = finaltitle + HANBIT_BREAKFAST_TIME;
            break;
        }
        break;
      case "별빛식당":
        switch (title) {
          case "점심":
            finaltitle = finaltitle + BYULBIT_LUNCH_TIME;
            break;
          case "저녁":
            //finaltitle = finaltitle + " ";
            break;
          default:
            //finaltitle = finaltitle + " ";
            break;
        }
        break;
      case "은하수식당":
        switch (title) {
          case "점심":
            finaltitle = finaltitle + ENHASU_LUNCH_TIME;
            break;
          case "저녁":
            finaltitle = finaltitle + ENHASU_DINNER_TIME;
            break;
          default:
            //finaltitle = finaltitle + " ";
            break;
        }
        break;
      case "양진재":
      case "양성재":
      case "본관":
        switch (title) {
          case "점심":
            finaltitle = (day == 'Sat' || day == 'Sun')
                ? finaltitle + YANGJINJAE_WEEKEND_LUNCH_TIME
                : finaltitle + YANGJINJAE_LUNCH_TIME;
            break;
          case "저녁":
            finaltitle = (day == 'Sat' || day == 'Sun')
                ? finaltitle + YANGJINJAE_WEEKEND_DINNER_TIME
                : finaltitle + YANGJINJAE_DINNER_TIME;
            break;
          default:
            finaltitle = (day == 'Sat' || day == 'Sun')
                ? finaltitle + YANGJINJAE_WEEKEND_BREAKFAST_TIME
                : finaltitle + YANGJINJAE_BREAKFAST_TIME;
            break;
        }
        break;
    }

    return Obx(
      () {
        Set<String> foodlist;
        foodlist = foodController.mealbytime[index];
        return foodlist.length != 0
            ? Column(
          children: [
            Center(
              child: Card(
                  color: WHITE_COLOR,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            finaltitle,
                            style: foodtimestyle,
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                            height: foodlist.length * 30 + 40,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: foodlist.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Text(
                                    foodlist.toList()[index],
                                    maxLines: 1,
                                    style: foodstyle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ]
                    ),
                  )
              ),
            ),
            const SizedBox(height: 20),
          ],
        )
            : const SizedBox(height: 0);
      },
    );
  }
}
