import "dart:convert";
import "dart:developer";

import "package:email_and_phone_verification/model/mock_codes_model.dart";
import "package:get/get.dart";
import "package:get/get_connect/connect.dart";

class NetworkService extends GetConnect {
  final String baseURL = "https://verify.twilio.com/v2/Services/";
  final String serviceSID = "VA605c5cb8f28479d89f86b14a21fb5e78/";

  Map<String, String> addAuthenticator() {
    const String accountSID = "AC1f60d3d97148597f50cb01da8b0a42f2";
    const String authToken = "ee3cbd9f30df8ee22aa9d544d5ffddb0";
    const String credentials = "$accountSID:$authToken";
    final Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    final String encoded = stringToBase64Url.encode(credentials);
    // final String decoded = stringToBase64Url.decode(encoded);
    final Map<String, String> headers = <String, String>{
      "Authorization": "Basic $encoded",
    };
    return headers;
  }

  Future<dynamic> postRequest({
    required String point,
    required Map<String, dynamic> body,
    required void Function(Map<String, dynamic>) decodedResponse,
    required void Function(String) failureHandler,
  }) async {
    Response<dynamic> response = const Response<dynamic>();
    try {
      response = await httpClient.post(
        baseURL + serviceSID + point,
        headers: addAuthenticator(),
        body: body,
        contentType: "application/x-www-form-urlencoded",
      );
    } on Exception catch (error) {
      failureHandler("Exception: postRequest(): ${error.toString()}");
    }
    response.body != null
        ? await commonMock(
            response: response,
            decodedResponse: decodedResponse,
            failureHandler: failureHandler,
          )
        : failureHandler("postRequest(): response.body: ${response.body}");
    return Future<dynamic>.value(response);
  }

  Future<void> commonMock({
    required Response<dynamic> response,
    required void Function(Map<String, dynamic>) decodedResponse,
    required void Function(String) failureHandler,
  }) async {
    final MockCodesModel reason = await mockCodes(response.statusCode ?? 100);
    reason.statusCode.toString().startsWith("2")
        ? decodedResponse(response.body)
        : failureHandler(
            mockMessage(reason),
          );
    return Future<void>.value();
  }

  Future<MockCodesModel> mockCodes(int code) async {
    MockCodesModel mockCodesModel = MockCodesModel();
    Response<dynamic> response = const Response<dynamic>();
    try {
      response = await httpClient.get("https://mock.codes/$code");
    } on Exception catch (error) {
      log("Exception: mockCodes(): ${error.toString()}");
    }
    response.body != null
        ? mockCodesModel = MockCodesModel.fromJson(response.body)
        : log("mockCodes(): response.body: ${response.body}");
    return Future<MockCodesModel>.value(mockCodesModel);
  }

  String mockMessage(MockCodesModel reason) {
    final String type = reason.statusCode.toString().startsWith("2")
        ? "type: 2×× Success\n"
        : reason.statusCode.toString().startsWith("3")
            ? "type: 3×× Redirection\n"
            : reason.statusCode.toString().startsWith("4")
                ? "type: 4×× Client Error\n"
                : reason.statusCode.toString().startsWith("5")
                    ? "type: 5×× Server Error\n"
                    : "Unknown Error\n";
    final String statusCode = "statusCode: ${reason.statusCode}\n";
    final String description = "description: ${reason.description}";
    return type + statusCode + description;
  }
}
