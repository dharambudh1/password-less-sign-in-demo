import "dart:async";

import "package:after_layout/after_layout.dart";
import "package:email_and_phone_verification/controllers/verification_controller.dart";
import "package:email_and_phone_verification/model/user_model.dart";
import "package:email_and_phone_verification/route/app_routes.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with AfterLayoutMixin<VerificationScreen> {
  final VerificationController _controller = Get.find();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments is List<dynamic>) {
        final List<dynamic> list = Get.arguments as List<dynamic>;
        if (list[0] is int && list[1] is UserModel) {
          final int type = list[0];
          final UserModel model = list[1];
          _controller
            ..updateType(type)
            ..updateUserModel(model)
            ..buildProperties();
        } else {}
      } else {}
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
    _formKey.currentState?.reset();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String channelName = _controller.getChannelType().name;
    final String channelVal = _controller.getChannelValue();
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify $channelName"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 14),
            Text("We've sent a 6 digit OTP to your $channelName:\n$channelVal"),
            const SizedBox(height: 14),
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _otpController,
                  onChanged: _controller.otpCode,
                  decoration: const InputDecoration(
                    labelText: "6 digit OTP",
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (String? value) {
                    return value == null || value.isEmpty
                        ? "Enter your OTP"
                        : value.length < 6
                            ? "Enter valid OTP"
                            : null;
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  await _controller.makeAPICall(
                    type: RequestType.verificationCheck,
                    successHandler: (String message) async {
                      showSnackBar(message);
                      await Get.toNamed(
                        AppRoutes().homeScreen,
                        arguments: <dynamic>[_controller.welcomeScreenArgs()],
                      );
                    },
                    failureHandler: showSnackBar,
                  );
                } else {}
              },
              child: const Text("Verify"),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message,
  ) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _controller.makeAPICall(
      type: RequestType.verifications,
      successHandler: showSnackBar,
      failureHandler: showSnackBar,
    );
    return Future<void>.value();
  }
}
