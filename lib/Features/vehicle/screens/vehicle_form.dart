import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/validators/validation.dart';
import '../controllers/vehicle_controller.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Vehicle Form')
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text('Add Vehicle', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Form
              const MAddVehicleForm(),

              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

class MAddVehicleForm extends StatelessWidget {
  const MAddVehicleForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VehicleController());
    return Form(
      key: controller.vehicleFormKey,
      child: Column(
      children: [
        
        TextFormField(
          controller: controller.vehicleNo,
          validator: (value) => MValidator.validateEmptyText('Vehicle No',value),
          expands: false,
          decoration: const InputDecoration(labelText: 'Vehicle Number:', prefixIcon: Icon(Iconsax.check)),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.vehicleType,
          validator: (value) => MValidator.validateEmptyText('Vehicle Type',value),
          expands: false,
          decoration: const InputDecoration(labelText: 'Vehicle Type:', prefixIcon: Icon(Iconsax.car)),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.vehicleBrand,
          validator: (value) => MValidator.validateEmptyText('Vehicle Brand',value),
          expands: false,
          decoration: const InputDecoration(labelText: 'Vehicle Brand:', prefixIcon: Icon(Iconsax.check)),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.vehicleNickname,
          validator: (value) => MValidator.validateEmptyText('Vehicle Nickname',value),
          expands: false,
          decoration: const InputDecoration(labelText: 'Vehicle Nickname:', prefixIcon: Icon(Iconsax.personalcard)),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.mileageTraveled,
          validator: (value) => MValidator.validateEmptyText('Mileage Travelled',value),
          expands: false,
          decoration: const InputDecoration(labelText: 'Mileage Travelled:', prefixIcon: Icon(Iconsax.ruler)),
          keyboardType: TextInputType.number,
        ), 
    
        const SizedBox(height: TSizes.spaceBtwSections),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.addVehicle(), child: const Text('Add Vehicle')))
      ])
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VehicleScreen(),
  ));
}
