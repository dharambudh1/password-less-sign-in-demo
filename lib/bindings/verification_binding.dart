import "package:email_and_phone_verification/controllers/verification_controller.dart";
import "package:get/get.dart";

class VerificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(VerificationController.new);
  }
}
