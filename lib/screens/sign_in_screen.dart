import "package:country_picker/country_picker.dart";
import "package:email_and_phone_verification/controllers/sign_in_controller.dart";
import "package:email_and_phone_verification/route/app_routes.dart";
import "package:flutter/material.dart";
import "package:fzregex/fzregex.dart";
import "package:fzregex/utils/pattern.dart";
import "package:get/get.dart";

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final SignInController _controller = Get.find();
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Color? primaryColorScheme;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _phoneCodeController.dispose();
    _phoneNumberController.dispose();
    _formKey.currentState?.reset();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    primaryColorScheme = Theme.of(context).buttonTheme.colorScheme?.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign-in"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            tabBar(),
            const SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: tabBarView(),
              ),
            ),
            button(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget tabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: primaryColorScheme,
      indicatorColor: primaryColorScheme,
      tabs: const <Tab>[
        Tab(text: "Email"),
        Tab(text: "Phone"),
      ],
    );
  }

  Widget tabBarView() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              onChanged: _controller.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                contentPadding: EdgeInsets.all(8.0),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                return value == null || value.isEmpty
                    ? "Enter your email"
                    : !Fzregex.hasMatch(value, FzPattern.email)
                        ? "Enter valid email"
                        : null;
              },
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _phoneCodeController,
                    onChanged: _controller.phoneCode,
                    decoration: const InputDecoration(
                      labelText: "Dial Code",
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      return value == null || value.isEmpty
                          ? "Enter your dial code"
                          : null;
                    },
                    readOnly: true,
                    onTap: showPhoneCodePicker,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    onChanged: _controller.phoneNumber,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (String? value) {
                      return value == null || value.isEmpty
                          ? "Enter your phone number"
                          : null;
                    },
                  ),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: SignInChannel.values.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Obx(
                  () {
                    return RadioListTile<SignInChannel>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(SignInChannel.values[index].name),
                      value: SignInChannel.values[index],
                      groupValue: SignInChannel.values[_controller.index.value],
                      onChanged: (SignInChannel? value) {
                        _controller.updateIndex(index);
                      },
                      activeColor: primaryColorScheme,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void showPhoneCodePicker() {
    return showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        final String phoneCode = "+${country.phoneCode}";
        _phoneCodeController.text = phoneCode;
        _controller.updatePhoneCode(phoneCode);
      },
    );
  }

  Widget button() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          await Get.toNamed(
            AppRoutes().verificationScreen,
            arguments: <dynamic>[
              if (_tabController.index == 0) 0 else _controller.index.value + 1,
              _controller.buildUserModel(),
            ],
          );
        } else {}
      },
      child: const Text("Continue"),
    );
  }
}
