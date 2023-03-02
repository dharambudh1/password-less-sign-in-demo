import "package:email_and_phone_verification/model/user_model.dart";
import "package:email_and_phone_verification/service/network_service.dart";
import "package:get/get.dart";

enum RequestType { verifications, verificationCheck }

enum Channel { email, sms, whatsapp, call }

class VerificationController extends GetxController {
  final NetworkService _networkService = Get.put(NetworkService());
  RxString otpCode = "".obs;
  RxInt channelType = 0.obs;
  RxString emailAddress = "".obs;
  RxString phoneCode = "".obs;
  RxString phoneNumber = "".obs;
  Rx<UserModel> userModel = UserModel().obs;

  void updateType(int type) {
    channelType(type);
    return;
  }

  void updateUserModel(UserModel model) {
    userModel(model);
    return;
  }

  void buildProperties() {
    emailAddress(userModel.value.emailAddress);
    phoneCode(userModel.value.phoneCode);
    phoneNumber(userModel.value.phoneNumber);
    return;
  }

  Channel getChannelType() {
    return channelType.value == 0
        ? Channel.email
        : channelType.value == 1
            ? Channel.sms
            : channelType.value == 2
                ? Channel.whatsapp
                : Channel.call;
  }

  String getChannelValue() {
    return channelType.value == 0
        ? emailAddress.value
        : "${phoneCode.value} ${phoneNumber.value}";
  }

  Future<void> makeAPICall({
    required RequestType type,
    required void Function(String) successHandler,
    required void Function(String) failureHandler,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    createRequestBody(type: type, channel: getChannelType(), data: data);
    await _networkService.postRequest(
      point: type.name.customCapitalize(),
      body: data,
      decodedResponse: (Map<String, dynamic> json) {
        handlerResponse(
          type: type,
          channel: getChannelType(),
          json: json,
          successHandler: successHandler,
          failureHandler: failureHandler,
        );
      },
      failureHandler: failureHandler,
    );
    return Future<void>.value();
  }

  void createRequestBody({
    required RequestType type,
    required Channel channel,
    required Map<String, dynamic> data,
  }) {
    String value = "";
    switch (channel) {
      case Channel.email:
        value = emailAddress.value;
        break;
      case Channel.sms:
        value = "${phoneCode.value}${phoneNumber.value}";
        break;
      case Channel.whatsapp:
        value = "${phoneCode.value}${phoneNumber.value}";
        break;
      case Channel.call:
        value = "${phoneCode.value}${phoneNumber.value}";
        break;
    }
    data.addAll(<String, dynamic>{"To": value});
    switch (type) {
      case RequestType.verifications:
        data.addAll(<String, dynamic>{"Channel": channel.name});
        break;
      case RequestType.verificationCheck:
        data.addAll(<String, dynamic>{"Code": otpCode.value});
        break;
    }
    return;
  }

  void handlerResponse({
    required RequestType type,
    required Channel channel,
    required Map<String, dynamic> json,
    required void Function(String) successHandler,
    required void Function(String) failureHandler,
  }) {
    switch (type) {
      case RequestType.verifications:
        successHandler("${channel.name} Sent!");
        break;
      case RequestType.verificationCheck:
        identityBoolean(json)
            ? successHandler("${channel.name} - OTP ${identityString(json)}!")
            : failureHandler("${channel.name} - OTP ${identityString(json)}!");
        break;
    }
    return;
  }

  bool identityBoolean(Map<String, dynamic> json) {
    return (json["valid"] is bool) && (json["valid"] ?? false);
  }

  String identityString(Map<String, dynamic> json) {
    return (json["valid"] is bool)
        ? (json["valid"] ?? false)
            ? "Verified"
            : "Mismatched"
        : "Not determined";
  }

  String welcomeScreenArgs() {
    final String via = "via ${getChannelType().name}";
    String value = "";
    switch (getChannelType()) {
      case Channel.email:
        value = "${emailAddress.value} $via";
        break;
      case Channel.sms:
        value = "${phoneCode.value} ${phoneNumber.value} $via";
        break;
      case Channel.whatsapp:
        value = "${phoneCode.value} ${phoneNumber.value} $via";
        break;
      case Channel.call:
        value = "${phoneCode.value} ${phoneNumber.value} $via";
        break;
    }
    return value;
  }
}

extension StringExtension on String {
  String customCapitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
