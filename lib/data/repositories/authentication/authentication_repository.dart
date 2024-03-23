import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:maintenex/Features/authentication/screens/signup/verify_email.dart';
import 'package:maintenex/features/authentication/screens/login/login.dart';
import 'package:maintenex/features/authentication/screens/onboarding/onboarding.dart';

import '../../../Features/Home/screens/home_screens.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;
  
  //Variables
  final deviceStorage = GetStorage();

  //App launch
  @override
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async{
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
    deviceStorage.writeIfNull('IsFirstTime', true);
    deviceStorage.read('IsFirstTime') != true 
      ? Get.offAll(() => const LoginScreen()) 
      : Get.offAll(OnboardingScreen());
    }
  }

  //Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async{
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  //Email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void>logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async{
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserFromAuth() async {
    try {
      // Get the current user

      // Check if the user is signed in
      if (authUser != null) {
        // Delete the user
        await authUser?.delete();
      } else {
        throw 'User is not signed in.';
      }
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}