import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/buttonpage.dart';
import 'package:ulife_final/listdata/listdata.dart';
import 'package:get/get.dart';

ListData lsta = ListData();
String dropdownvalue = lsta.departmentlist.first;

class ButtonBlock extends StatelessWidget {
  String title;
  List<String> buttonList;

  ButtonBlock({required this.title, required this.buttonList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonPageController buttonPageController = Get.find();
    // int? _majorvalue;

    Widget Department = Obx(() => Wrap(
          spacing: 8.0,
          children: List<Widget>.generate(
            title == "소속 학과/학부"
                ? buttonPageController.majors.length
                : buttonPageController.dorms.length,
            (int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: InputChip(
                  label: Text(
                    title == "소속 학과/학부"
                        ? buttonPageController.majors[index]
                        : buttonPageController.dorms[index],
                  ),
                  onDeleted: () {
                    switch (title) {
                      case "소속 학과/학부":
                        buttonPageController
                            .removeMajors(buttonPageController.majors[index]);
                        break;
                      case "기숙사":
                        buttonPageController
                            .removeDorms(buttonPageController.dorms[index]);
                        break;
                      case "글 보기":
                        buttonPageController.setViewOption("");
                        break;
                    }
                  },
                ),
              );
            },
          ).toList(),
        ));
    Widget Return1 = Obx(
          () => Wrap(
        spacing: 8.0,
        children: List<Widget>.generate(
          buttonList.length,
              (int index) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: ChoiceChip(
                  label: Text(
                    buttonList[index],
                  ),
                  selected: buttonPageController.values[title] == index,
                  onSelected: (bool selected) {
                    if (selected) {
                      buttonPageController.values[title] = index;
                      switch (title) {
                        case "기숙사":
                          if (buttonList[index] == "없음") {
                            buttonPageController.setDorms([]);
                          } else {
                            buttonPageController
                                .addDorms(buttonList[index]);
                          }

                          break;
                        case "글 보기":
                          buttonPageController
                              .setViewOption(buttonList[index]);
                          break;
                      }
                    } else {
                      buttonPageController.values[title] = null;
                      switch (title) {
                        case "기숙사":
                          buttonPageController
                              .removeDorms(buttonList[index]);
                          break;
                      }
                    }
                  },
                ));
          },
        ).toList(),
      ),
    );

    Widget Return2 = Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                      value: dropdownvalue,
                      items: lsta.departmentlist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? value) {
                        buttonPageController.entireMajor.value = [];
                        dropdownvalue = value!;
                        buttonPageController.entireMajor
                            .addAll(lsta.majorlist(value));
                      }),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8.0,
                    children: List<Widget>.generate(
                      buttonPageController.entireMajor.length,
                      (int index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Obx(() {
                              return ChoiceChip(
                                label: Text(
                                  buttonPageController.entireMajor[index],
                                ),
                                selected:
                                    buttonPageController.majorvalue.value ==
                                        index,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    buttonPageController.majorvalue.value =
                                        index;
                                    buttonPageController.addMajors(
                                        buttonPageController
                                            .entireMajor[index]);
                                  } else {
                                    buttonPageController.majorvalue?.value = -1;
                                    buttonPageController.removeMajors(
                                        buttonPageController
                                            .entireMajor[index]);
                                  }
                                },
                              );
                            }));
                      },
                    ).toList(),
                  ),
                ],
              )),
          const SizedBox(height: 12.0),
        ]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: const BoxDecoration(
        color: WHITE_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${title}", style: applytitletextstyle,),

          Container(

            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: title == "소속 학과/학부" ? Return2 : Return1,
                    ),
                    const Divider(thickness: 1, height: 8,),
                    title == "소속 학과/학부"
                        ? Department
                        : title == "기숙사"
                        ? Department
                        : const SizedBox(),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
