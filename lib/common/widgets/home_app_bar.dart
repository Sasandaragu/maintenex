import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maintenex/Features/aboutUs/screens/aboutus_screen.dart';
import 'package:maintenex/Features/personalization/controllers/user_controller.dart';
import 'package:maintenex/Features/personalization/screens/profile.dart';
import 'package:maintenex/common/widgets/appbar.dart';
import 'package:maintenex/common/widgets/circular_image.dart';
import 'package:maintenex/common/widgets/primary_header_container.dart';
import 'package:maintenex/utils/constants/colors.dart';
import 'package:maintenex/utils/constants/image_strings.dart';
import 'package:maintenex/utils/constants/sizes.dart';

class MHomeAppBar extends StatelessWidget {
  const MHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Column(
      children: [
        //Header
        TPrimaryHeaderContainer(
            child: Column(
          children: [
            TAppBar(
              title: Text('Home',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(color: TColors.white)),
              leadingIcon: Icons.home,
              actions: [
                IconButton(
                  onPressed: () => Get.to(() => const AboutUsPage()),
                  icon: const Icon(Iconsax.info_circle, color: TColors.white),
                ),
              ],
            ),

            //User Profile Card
            ListTile(
              leading: const MCircularImage(image: TImage.user),
              title: Obx(
                () => Text(controller.user.value.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(color: TColors.white)),
              ),
              subtitle: Obx(
                () => Text(controller.user.value.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.white)),
              ),
              trailing: IconButton(
                  onPressed: () => Get.to(() => const ProfileScreen()),
                  icon: const Icon(Iconsax.profile_circle, color: TColors.white)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        )),
      ],
    );
  }
}
