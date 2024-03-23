import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/mileage/models/mileage_record_model.dart';
import 'package:maintenex/Features/personalization/models/user_model.dart';
import 'package:maintenex/Features/vehicle/models/vehicle_model.dart';
import 'package:maintenex/data/repositories/mileage/mileage_repository.dart';
import 'package:maintenex/data/repositories/user/user_repository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  final vehicleLoading = false.obs;
  Rx<VehicleModel> vehicle = VehicleModel.empty().obs;
  final vehicleRepository = Get.put(VehicleRepository());


  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
    fetchVehicleRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

    Future<void> fetchVehicleRecord() async {
    try {
      vehicleLoading.value = true;
      final vehicle = await vehicleRepository.fetchVehicleDetails();
      this.vehicle(vehicle);
    } catch (e) {
      vehicle(VehicleModel.empty());
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {

        // Convert Name to First and Last Name
        final nameParts = UserModel.nameParts (userCredentials.user!.displayName ?? '');
        final username = UserModel.generateUsername (userCredentials.user!.displayName?? '');
      
        // Map Data
        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length> 1 ? nameParts.sublist(1).join(' ') : '',
          username: username,
          email: userCredentials.user!.email ?? '',
          phoneNumber: userCredentials.user!.phoneNumber ?? '',
        );
      // Save user data
      await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      MLoaders.warningSnackBar (
      title: 'Data not saved',
      message: 'Something went wrong while saving your information. You can re-save your data in your profile.',
      );
    }
  }
}