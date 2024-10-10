import 'package:flutter/material.dart';
import 'package:ulife_final/const/style.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
            body: SafeArea(
              child: Center(
                child: Text(
                  "조건에 맞는 공지가 없습니다.",
                  style: emptystyle,
                ),
              ),
            ),
          );
  }
}
