import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:maintenex/common/widgets/success_screen.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/utils/constants/image_strings.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class VerifyEmailController extends GetxController{
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      MLoaders.successSnackBar(title: 'Email Sent', message: 'Please Check your inbox and verify your email.');
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  setTimerForAutoRedirect() async {
    Timer.periodic(
      const  Duration(seconds: 1), 
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified ?? false){
          timer.cancel();
          Get.off(() => Success_screen(
            image: TImage.successfullyCreated, 
            title: 'Your Account Successfully Created and Verified', 
            subtitle: '',
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          )
        );
      }
    });
  }

  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => Success_screen(
          image: TImage.successfullyCreated, 
          title: 'Your Account Successfully Created and Verified', 
          subtitle: '', 
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}