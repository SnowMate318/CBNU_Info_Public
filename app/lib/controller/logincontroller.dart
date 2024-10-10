import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulife_final/controller/controller_keyword.dart';
import 'package:ulife_final/controller/controller_user.dart';
import 'package:ulife_final/screen/loginscreen.dart';
import '../model/user/user_data.dart';
import '../screen/mainscreen.dart';

class LoginController extends GetxController{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MyInfo myInfo = Get.find();

  // 로그인 상태 관리를 위한 변수 추가
  var isLoggingIn = false.obs;

  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Get.to(() => LoginScreen());
      } else {
        print('User is signed in!');
        Get.to(() => MainScreen());
      }
    });
    super.onInit();
  }

  Future<void> login() async {
    try {
      //isLoggingIn(true); // 로그인 시작 시 버튼 비활성화
      await createUser();
      // 로그인 성공 후 화면 전환은 authStateChanges() 리스너에서 처리
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("익명 로그인이 불가능합니다.");
          break;
        default:
          debugPrint("발견하지 못한 에러.: ${e.code}");
      }
    } finally {
      //isLoggingIn(false); // 작업 완료 후 다시 버튼 활성화
    }
  }

  Future<void> logout() async {
    User user = auth.currentUser!;
    KeywordController keywordController = Get.find();
    await keywordController.deleteAllKeyword(user, myInfo.getUserFcmToken(), true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await deleteUser(user);
    // 로그아웃 후 추가적인 UI 업데이트가 필요하면 여기서 처리
  }


  // Future<String?> getFirebaseToken() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     return await user.getIdToken();
  //   }
  //   return null;
  // }
  //
  //
  // Future<void> sendUserData(String uid) async {
  //   String? token = await getFirebaseToken();
  //   if (token == null) {
  //     print('Firebase 인증 토큰을 얻는 데 실패했습니다.');
  //     return;
  //   }
  //   String? udid;
  //   // if(!kIsWeb){
  //   //   if (Platform.isAndroid || Platform.isIOS) {
  //   //     udid = await FlutterUdid.consistentUdid;
  //   //   }
  //   // }
  //
  //   var url = Uri.parse('https://info.cbnu.ac.kr/api/user/');
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',  // Firebase 인증 토큰 추가
  //     },
  //     body: json.encode({
  //       'uid': uid,
  //       'udid': udid,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('데이터를 성공적으로 보냈습니다: ${response.body}');
  //   } else {
  //     print('데이터룰 보내는데 실패했습니다: ${response.statusCode}');
  //   }
  // }
  //
  // Future<void> deleteUserData(String uid) async {
  //   var url = Uri.parse('https://info.cbnu.ac.kr/api/user/$uid/');  // 서버의 URL과 사용자 ID를 사용하여 엔드포인트 구성
  //   String? token = await getFirebaseToken();
  //   var response = await http.delete(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //
  //   if (response.statusCode == 204) {
  //     // 성공적으로 삭제되었을 때의 처리
  //     print('User deleted successfully');
  //   } else {
  //     // 삭제 실패 시의 처리
  //     print('Failed to delete user: ${response.statusCode}');
  //   }
  // }
}


