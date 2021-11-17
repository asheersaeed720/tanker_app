import 'package:get/get.dart';
import 'package:tanker_app/src/auth/auth_controller.dart';
import 'package:tanker_app/src/network_manager.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
