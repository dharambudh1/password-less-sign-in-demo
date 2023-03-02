import "package:email_and_phone_verification/bindings/sign_in_binding.dart";
import "package:email_and_phone_verification/bindings/verification_binding.dart";
import "package:email_and_phone_verification/screens/home_screen.dart";
import "package:email_and_phone_verification/screens/sign_in_screen.dart";
import "package:email_and_phone_verification/screens/verification_screen.dart";
import "package:get/get.dart";
import "package:get/get_navigation/src/routes/get_route.dart";

class AppRoutes {
  final String signInScreen = "/";
  final String verificationScreen = "/verificationScreen";
  final String homeScreen = "/homeScreen";

  List<GetPage<dynamic>> getPages() {
    return <GetPage<dynamic>>[
      GetPage<dynamic>(
        name: signInScreen,
        page: SignInScreen.new,
        binding: SignInBinding(),
      ),
      GetPage<dynamic>(
        name: verificationScreen,
        page: VerificationScreen.new,
        binding: VerificationBinding(),
      ),
      GetPage<dynamic>(
        name: homeScreen,
        page: HomeScreen.new,
      ),
    ];
  }
}
