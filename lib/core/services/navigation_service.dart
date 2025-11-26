import 'package:get/get.dart';

class NavigationService {
  Future<dynamic>? navigateTo(String routeName, {dynamic arguments}) {
    return Get.toNamed(routeName, arguments: arguments);
  }

  void goBack() {
    Get.back();
  }
}
