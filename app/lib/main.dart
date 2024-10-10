import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ulife_final/bindings.dart';
import 'package:ulife_final/controller/controller_keyword.dart';
import 'package:ulife_final/controller/update.dart';
import "package:flutter/material.dart";
import 'package:ulife_final/screen/foodscreen.dart';
import 'package:ulife_final/screen/infoscreen.dart';
import 'package:ulife_final/screen/mainscreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ulife_final/screen/settingscreen.dart';
import 'package:ulife_final/screen/subscribescreen.dart';
import 'controller/controller_user.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:ulife_final/controller/announcement.dart';
import 'package:ulife_final/controller/tabviewitem.dart';
import 'package:ulife_final/controller/viewoption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulife_final/screen/loginscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await Permission.notification.request();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'high_importance_notification',
        importance: Importance.max)
    );


  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    iOS: DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    )
  ));





  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null && Platform.isAndroid) { // 안드로이드에서만 실행
      Future.delayed(const Duration(milliseconds: 3000), () {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          //payload: message.data['test_parameter1']
        );
        debugPrint("수신자 측 메시지 수신");
      });
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    if (message != null) {
      debugPrint("메시지 수신");
    }
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...

  }

}
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeNotification();
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    // save token to server

  });
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String? uid;
  if(user!=null){
    uid = user.uid;
  }
  Get.put(MyInfo());
  Get.put(KeywordController());
  Get.put(CampusAnnController());
  Get.put(ExtracurAnnController());
  Get.put(CieatController());
  Get.put(MyScrollController());
  Get.put(FoodController());
  Get.put(MainScreenFoodController());
  Get.put(ViewOptionController());
  Get.put(TabviewItemController());

  runApp(MyApp(user: user, uid: uid));
}

class MyApp extends StatelessWidget {
  TabviewItemController tabviewItemController = Get.find();
  ViewOptionController viewOptionController = Get.find();
  CampusAnnController campusAnnController = Get.find();
  ExtracurAnnController extracurAnnController = Get.find();
  CieatController cieatController = Get.find();
  MainScreenFoodController mainScreenFoodController = Get.find();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  User? user;
  String? uid;
  MyApp({
    required this.user,
    required this.uid,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      getPages: [
        GetPage(
          name: '/',
          page: () => MainScreen(),
        ),
        GetPage(
          name: '/informations',
          page: () => InfoScreen(),
        ),
        GetPage(
          name: '/food',
          page: () => FoodScreen(),
        ),
        GetPage(
          name: '/subscribe',
          page: () => SbuscribeScreen(),
          bindings: [
            ButtonPageBinding(),
            NotificationBinding(),
          ]
        ),
        GetPage(
          name: '/setting',
          page: () => SettingScreen(),
        ),
      ],
      home: user!=null ? MainScreen() : const LoginScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(125, 34, 72, 1.0),
        scaffoldBackgroundColor: Color.fromRGBO(230, 224, 233, 1.0),
      ),
    );
  }
}
