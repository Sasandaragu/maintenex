import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/utils/helpers/network_manager.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> ForgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          throw "Network error";
        }

      await AuthenticationRepository.instance.sendResetPasswordEmail(email.text.trim());

      MLoaders.successSnackBar(title: 'Success', message: 'Password Reset Link has been Sent');

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }
}