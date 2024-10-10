import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulife_final/const/colors.dart';
import 'package:ulife_final/const/style.dart';
import 'package:ulife_final/controller/logincontroller.dart';
import 'package:ulife_final/screen/mainscreen.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final LoginController loginController = Get.put(LoginController());
//
//     return Scaffold(
//       body: Center(
//         child: OutlinedButton(
//           onPressed: (){
//             loginController.login();
//           },
//           child: Text(
//             "익명 로그인",
//           ),
//         )
//       ),
//     );
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggingIn = false; // 로그인 중인지 아닌지를 추적하는 플래그

  void attemptLogin() async {
    setState(() {
      isLoggingIn = true; // 로그인 중으로 상태 변경
    });
    final LoginController loginController = Get.put(LoginController());
    await loginController.login(); // 실제 로그인 로직을 실행

    await Future.delayed(const Duration(seconds: 5)); // 5초 대기

    setState(() {
      isLoggingIn = false; // 로그인 프로세스 종료
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: WHITE_COLOR,
        child: Center(
          child: OutlinedButton(
            onPressed: isLoggingIn ? null : attemptLogin, // isLoggingIn이 true일 때 버튼 비활성화
            child: isLoggingIn
                ? const Text("로그인 중...") // 로그인 중일 때의 텍스트
                : const Text("익명 로그인"), // 기본 텍스트
          ),
        ),
      ),
    );
  }
}