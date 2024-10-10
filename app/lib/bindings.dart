
import 'package:get/instance_manager.dart';
import 'package:ulife_final/controller/buttonpage.dart';
import 'package:ulife_final/controller/controller_notification.dart';

class ButtonPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ButtonPageController());
  }
}

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}