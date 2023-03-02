import "package:email_and_phone_verification/model/user_model.dart";
import "package:get/get.dart";

enum SignInChannel { sms, whatsapp, call }

class SignInController extends GetxController {
  RxString emailAddress = "".obs;
  RxString phoneCode = "".obs;
  RxString phoneNumber = "".obs;
  RxInt index = 0.obs;

  void updatePhoneCode(String code) {
    phoneCode(code);
    return;
  }

  UserModel buildUserModel() {
    return UserModel(
      emailAddress: emailAddress.value,
      phoneCode: phoneCode.value,
      phoneNumber: phoneNumber.value,
    );
  }

  void updateIndex(int i) {
    index(i);
    return;
  }
}
