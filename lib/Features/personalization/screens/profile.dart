import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/personalization/controllers/user_controller.dart';
import 'package:maintenex/common/widgets/appbar.dart';
import 'package:maintenex/common/widgets/circular_image.dart';
import 'package:maintenex/common/widgets/confirmation.dart';
import 'package:maintenex/common/widgets/profile_menu.dart';
import 'package:maintenex/common/widgets/section_heading.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/user/user_repository.dart';
import 'package:maintenex/utils/constants/image_strings.dart';
import 'package:maintenex/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build (BuildContext context) {

    final controller = Get.put(UserController());

    return Scaffold(
      appBar: const TAppBar (showBackArrow: true, title: Text('Profile')),
 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all (TSizes.defaultSpace),
          child: Column (
            children: [
              /// Profile Picture
              const SizedBox(
                width: double.infinity,
                child: Column (
                  children: [
                    MCircularImage (image: TImage.user, width: 80, height: 80),
                  ],
                ),
              ), 

              const SizedBox(height:TSizes.spaceBtwItems/2),
              const Divider(),
              const SizedBox(height:TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height:TSizes.spaceBtwItems),

              Obx(() => MProfileMenu(onPressed: (){}, title: 'Name', value: controller.user.value.fullName)),
              Obx(() => MProfileMenu(onPressed: (){}, title: 'Username', value: controller.user.value.username)),

              const SizedBox(height:TSizes.spaceBtwItems/2),
              const Divider(),
              const SizedBox(height:TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height:TSizes.spaceBtwItems),

              Obx(() => MProfileMenu(onPressed: (){}, title: 'User ID', value: controller.user.value.id)),
              Obx(() => MProfileMenu(onPressed: (){}, title: 'E-mail', value: controller.user.value.email)),
              Obx(() => MProfileMenu(onPressed: (){}, title: 'Phone Number', value: controller.user.value.phoneNumber)),

              const SizedBox(height:TSizes.spaceBtwItems/2),
              const Divider(),
              const SizedBox(height:TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => AuthenticationRepository.instance.logout(),
                  icon: Icon(Icons.exit_to_app), // Icon for logout
                  label: const Text('Logout'),
                ),
              ),


              const SizedBox(height:TSizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        message: 'Are you sure you want to proceed?',
                        onYesPressed: () async {
                          UserRepository.instance.removeUserRecord();                 
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete), // Bin icon
                      const SizedBox(width: 8), // Spacer between icon and text
                      const Text('Delete Account'), // Text
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ), 
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileScreen(),
  ));
}