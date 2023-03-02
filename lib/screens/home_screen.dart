import "package:flutter/material.dart";
import "package:get/get.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: Center(
          child: Text("Welcome, ${(Get.arguments as List<dynamic>)[0]}"),
        ),
      ),
    );
  }
}
