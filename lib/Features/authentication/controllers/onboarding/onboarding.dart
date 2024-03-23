// lib/controllers/onboarding_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/onboarding/onboarding.dart';
import '../../screens/login/login.dart';


class OnboardingController with ChangeNotifier {
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
      title: '''Welcome to Maintenex Vehicle Companion''',
      description: "Keep track of your vehicle's maintenance, fuel usage, and more with Maintenex.",
      imageAsset: 'assets/images/onboarding/Onboarding1.png',
    ),
    OnboardingInfo(
      title: 'Easy Maintenance Tracking',
      description: "Record your vehicle's service history, fuel history, mileage, set reminders, and stay on top of maintenance tasks effortlessly.",
      imageAsset: 'assets/images/onboarding/Onboarding2.png',
    ),
    OnboardingInfo(
      title: 'Document Management Made Simple',
      description: "Upload and manage your vehicle's documents, such as insurance papers and registration, all in one place with Maintenex.",
      imageAsset: 'assets/images/onboarding/Onboarding3.png',
    ),
    OnboardingInfo(
      title: 'Insightful Monthly Reports',
      description: "Generate detailed monthly reports to analyze your vehicle's performance, expenses, and more with Maintenex.",
      imageAsset: 'assets/images/onboarding/Onboarding4.png',
    ),
  ];

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < onboardingPages.length - 1) {
      pageController.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }else{
      Get.offAll(const LoginScreen());
      final storage = GetStorage();

      if(kDebugMode){
      print(storage.read('IsFirstTime'));
    }
    
      storage.write('IsFirstTime', false);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
