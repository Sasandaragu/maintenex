import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/authentication/screens/signup/verify_email.dart';
import 'package:maintenex/Features/personalization/models/user_model.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/user/user_repository.dart';
import 'package:maintenex/utils/helpers/network_manager.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try{

      //Start Loading
      //TFullScreenLoader.openLoadingDialog('Proccessing...', TImage.verifyIllustration);
      MLoaders.customToast(message: 'Proccessing...');

      //Network connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //TFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if(!signupFormKey.currentState!.validate()){
        //TFullScreenLoader.stopLoading();
        return;
      }

      //Privacy Policy
      if (!privacyPolicy.value){
        MLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.'
          );
          return;
      }

      //Store in Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      final newUser = UserModel(
        id: userCredential.user!.uid, 
        firstName: firstName.text.trim(), 
        lastName: lastName.text.trim(), 
        username: username.text.trim(), 
        email: email.text.trim(), 
        phoneNumber: phoneNumber.text.trim()
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      //TFullScreenLoader.stopLoading();
    
      //Success message
      MLoaders.successSnackBar(title: 'Congratulations', message: 'Your Account has been Created! Verify Email to Continue');
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));

    } catch (e) {
      //TFullScreenLoader.stopLoading();
      MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }
}