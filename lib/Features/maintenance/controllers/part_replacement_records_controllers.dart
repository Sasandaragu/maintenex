import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../../data/repositories/maintenex/part_replacement/partReplacementRecordRepository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/poppups/loaders.dart';
import '../../Home/screens/home_screens.dart';
import '../models/part_replacement_record/part_raplacement_record_model.dart';
import '../screens/part_replacement_records_screen.dart';


class PartReplacementRecordController {
  final PartReplacementRecordRepository _repository =
      PartReplacementRecordRepository();

  Future<void> submitPartReplacementRecord(
      {required String replacedPart,
      required String serviceProvider,
      required String date,
      required double recommendedMileage,
      required double recommendedLifetime,
      required double warranty,
      required double totalCost,
      required String description,
      List<PlatformFile>? files,
      bool enableAlert = false}) async {
    final newPartReplacementRecord = PartReplacementRecordModel(
        replacedPart: replacedPart,
        serviceProvider: serviceProvider,
        date: date,
        totalCost: totalCost,
        description: description,
        recommendedLifetime: recommendedLifetime,
        recommendedMileage: recommendedMileage,
        warranty: warranty,
        enableAlert: enableAlert);

    try {
      if (enableAlert == true &&
          (recommendedMileage < 1 && recommendedLifetime < 1)) {
        throw "For recieve alerts you need to fill either Mileage, Lifetime or Both";
      }

      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      await _repository.addPartReplacementRecord(
          newPartReplacementRecord, files);

      MLoaders.successSnackBar(
          title: 'Success', message: 'Part Replacement Record has been Added');
      Get.to(() => const HomeScreen());
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> deletePartReplacementRecord(
      {required PartReplacementRecordModel partReplacementRecord}) async {
    try {
      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      await _repository.deletePartReplacementRecord(
          partReplacementRecord: partReplacementRecord);
      MLoaders.successSnackBar(
          title: 'Success',
          message: 'part Replacement Record has been Deleted');
      Get.to(() => const PartReplacementRecordsScreen());
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> removeAlert(
      {required PartReplacementRecordModel partReplacementRecord}) async {
    try {
      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      await _repository.RemoveAlert(
          partReplacementRecord: partReplacementRecord);
      MLoaders.successSnackBar(
          title: 'Success', message: 'Alert has been Removed');
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
