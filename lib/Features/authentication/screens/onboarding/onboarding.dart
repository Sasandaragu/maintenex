// lib/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../../controllers/onboarding/onboarding.dart';
import '../../models/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingController(),
      child: Scaffold(
        body: Consumer<OnboardingController>(
          builder: (context, controller, child) {
            return Stack(
              children: [
                PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onboardingPages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(controller.onboardingPages[index]);
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: List.generate(
                      controller.onboardingPages.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<OnboardingController>(
          builder: (context, controller, child) {
            return FloatingActionButton(
              onPressed: () {
                controller.nextPage();
              },
              child: Icon(Icons.arrow_forward),
            );
          },
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    OnboardingController controller = Provider.of<OnboardingController>(context);
    return Container(
      height: 10,
      width: controller.currentPage == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: controller.currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingInfo info;

  OnboardingPage(this.info);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(info.imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 90),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(info.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black)),
          ),
          Spacer(), // Spacer to push the description to the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(info.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
