import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../../data/repositories/maintenex/service_record/serviceRecordRepository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/poppups/loaders.dart';
import '../../Home/screens/home_screens.dart';
import '../models/service_record/service_record_model.dart';
import '../screens/service_records_screen.dart';


class ServiceRecordController {
  final ServiceRecordRepository _repository = ServiceRecordRepository();

  Future<void> submitServiceRecord({
    required String serviceProvider,
    required String date,
    required double recommendedMileage,
    required double recommendedLifetime,
    required double totalCost,
    required String description,
    List<PlatformFile>? invoiceFiles,
    bool enableAlert = false,
  }) async {

    final newServiceRecord = ServiceRecordModel(
      serviceProvider: serviceProvider, 
      date: date, totalCost: 
      totalCost, 
      description: description,
      recommendedLifetime: recommendedLifetime,
      recommendedMileage: recommendedMileage,
      enableAlert: enableAlert);



    try {

        if (enableAlert == true && (recommendedMileage < 1 && recommendedLifetime < 1)) {
          throw "For recieve alerts you need to fill either Mileage, Lifetime or Both";
        }

        MLoaders.customToast(message: 'Proccessing...');

        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          throw "Network error";
        }
        
    await _repository.addServiceRecord(newServiceRecord, invoiceFiles);

    MLoaders.successSnackBar(title: 'Success', message: 'Service Record has been Added');
    Get.to(() => const HomeScreen());

    } catch (e) {
        MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  Future<void> deleteServiceRecord({
    required ServiceRecordModel serviceRecord
  }) async {

    try {

      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      await _repository.deleteServiceRecord(serviceRecord: serviceRecord);
      MLoaders.successSnackBar(title: 'Success', message: 'Service Record has been Deleted');
      Get.to(() => const ServiceRecordsScreen());

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  Future<void> removeAlert({
    required ServiceRecordModel serviceRecord
  }) async {

    try {

      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      await _repository.RemoveAlert(serviceRecord: serviceRecord);
      MLoaders.successSnackBar(title: 'Success', message: 'Alert has been Removed');

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }
}

