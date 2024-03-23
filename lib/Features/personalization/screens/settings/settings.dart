import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/common/widgets/home_app_bar.dart';

class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: MHomeAppBar()
      ),
    );
  }
}

void main() {
  runApp(const GetMaterialApp(
    home: SettingsScreen(),
    ));
}