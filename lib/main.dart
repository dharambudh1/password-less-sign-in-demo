import "package:country_picker/country_picker.dart";
import "package:email_and_phone_verification/bindings/sign_in_binding.dart";
import "package:email_and_phone_verification/route/app_routes.dart";
import "package:email_and_phone_verification/screens/sign_in_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:get/get.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: GetMaterialApp(
        title: "Flutter Demo",
        theme: themeData(Brightness.light),
        darkTheme: themeData(Brightness.dark),
        supportedLocales: const <Locale>[Locale("en")],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const SignInScreen(),
        enableLog: false,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes().signInScreen,
        initialBinding: SignInBinding(),
        getPages: AppRoutes().getPages(),
      ),
    );
  }

  ThemeData themeData(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: Colors.blue,
    );
  }
}
