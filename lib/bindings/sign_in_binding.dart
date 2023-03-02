import "package:email_and_phone_verification/controllers/sign_in_controller.dart";
import "package:get/get.dart";

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SignInController.new);
  }
}
