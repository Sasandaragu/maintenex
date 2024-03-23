import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:maintenex/bindings/general_bindings.dart';
import 'package:maintenex/utils/constants/colors.dart';
import 'package:maintenex/utils/constants/text_strings.dart';
import 'package:maintenex/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TText.appName,
      theme: TAppTheme.lightTheme,
      initialBinding: GeneralBindings(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(backgroundColor: TColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}