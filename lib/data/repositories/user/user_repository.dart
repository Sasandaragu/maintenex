import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/personalization/models/user_model.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserRecord() async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    try {
      await _db.collection("Users").doc(userID).delete();
      AuthenticationRepository.instance.logout();
      AuthenticationRepository.instance.deleteUserFromAuth();
      MLoaders.successSnackBar(title: 'Success', message: 'Account has been Deleted');
    } catch (e) {
      rethrow;
    }
  }
}
