import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/Home/screens/home_screens.dart';
import 'package:maintenex/Features/maintenance/models/repair_record/repair_record_model.dart';
import 'package:maintenex/data/repositories/maintenex/repair_record/repairRecordRepository.dart';
import 'package:maintenex/utils/helpers/network_manager.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class RepairRecordController {
  final RepairRecordRepository _repository = RepairRecordRepository();

  Future<void> submitRepairRecord({
    required String serviceProvider,
    required String date,
    required double totalCost,
    required String description,
    List<PlatformFile>? invoiceFiles,
  }) async {

    final newRepairRecord = RepairRecordModel(
      serviceProvider: serviceProvider, 
      date: date, totalCost: 
      totalCost, 
      description: description);

    try {

        MLoaders.customToast(message: 'Proccessing...');

        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          throw "Network error";
        }
        
    await _repository.addRepairRecord(newRepairRecord, invoiceFiles);

    MLoaders.successSnackBar(title: 'Success', message: 'Repair Record has been Added');
    Get.to(() => const HomeScreen());

    } catch (e) {
        MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }
}

