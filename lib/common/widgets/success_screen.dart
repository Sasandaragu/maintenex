import 'package:flutter/material.dart';
import 'package:maintenex/common/styles/spacing_styles.dart';
import 'package:maintenex/utils/constants/image_strings.dart';
import 'package:maintenex/utils/constants/sizes.dart';
import 'package:maintenex/utils/constants/text_strings.dart';
import 'package:maintenex/utils/helpers/helper_functions.dart';

class Success_screen extends StatelessWidget {
  const Success_screen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image, title, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:TSpacingStyle.paddingWithAppBarHeight*2,
          child: Column(
            children: [
              //Image
              //Lottie.asset(image,width: MediaQuery.of(context).size.width*0.6),
              Image(image: const AssetImage(TImage.staticSuccessIllustration), width: THelperFunctions.screenWidth()*0.6,),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Title & Subtitle
              Text(title,style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(subtitle,style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Button
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(onPressed: onPressed, child: const Text(TText.tContinue))
              ),
            ]
          )
        )
      )
    );
  }
}