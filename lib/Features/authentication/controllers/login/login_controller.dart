import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/utils/helpers/network_manager.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class LoginController extends GetxController {
  
  final remenberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  
  @override
  void onInit() {
    final rememberedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final rememberedPassword = localStorage.read('REMEMBER_ME_PASSWORD');

    if (rememberedEmail != null) {
      email.text = rememberedEmail;
    }
    if (rememberedPassword != null) {
      password.text = rememberedPassword;
    }

    super.onInit();
  }

  void emailAndPasswordSignIn() async {
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
      if(!loginFormKey.currentState!.validate()){
        //TFullScreenLoader.stopLoading();
        return;
      }

      //Privacy Policy
      if (remenberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      //Store in Firebase
      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      AuthenticationRepository.instance.screenRedirect();
      
    } catch (e) {
      //TFullScreenLoader.stopLoading();
      MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }
}