import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/signup/signup_controller.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text(TText.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Form
              const TSignupForm(),

              const SizedBox(height: TSizes.spaceBtwSections),

              ///Divider
              // TFormDivider(dividerText: TText.orSignUpWith.capitalize!),
              // const SizedBox(height: TSizes.spaceBtwSections),

              // ///Social Button
              // const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
      children: [

        TextFormField(
          controller: controller.firstName,
          validator: (value) => MValidator.validateEmptyText('First Name',value),
          expands: false,
          decoration: const InputDecoration(labelText: TText.firstName, prefixIcon: Icon(Iconsax.user),contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),border: InputBorder.none),
        ),
  
        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.lastName,
          validator: (value) => MValidator.validateEmptyText('Last Name',value),
          expands: false,
          decoration: const InputDecoration(labelText: TText.lastName, prefixIcon: Icon(Iconsax.user),contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),border: InputBorder.none),
        ),
    
        const SizedBox(height: TSizes.spaceBtwInputFields),
        
        ///UserName
        TextFormField(
          controller: controller.username,
          validator: (value) => MValidator.validateEmptyText('Username',value),
          expands: false,
          decoration: const InputDecoration(labelText: TText.username, prefixIcon: Icon(Iconsax.user_edit),contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),border: InputBorder.none),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),
    
        ///Email
        TextFormField(
          controller: controller.email,
          validator: (value) => MValidator.validateEmail(value),
          expands: false,
          decoration: const InputDecoration(labelText: TText.email, prefixIcon: Icon(Iconsax.direct),contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),border: InputBorder.none),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),
    
        ///phoneNumber
        TextFormField(
          controller: controller.phoneNumber,
          validator: (value) => MValidator.validatePhoneNumber(value),
          expands: false,
          decoration: const InputDecoration(labelText: TText.phoneNo, prefixIcon: Icon(Iconsax.call),contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),border: InputBorder.none),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),
    
        ///Password
        Obx(
          () => TextFormField(
            controller: controller.password,
            validator: (value) => MValidator.validatePassword(value),
            expands: false,
            obscureText: controller.hidePassword.value,
            decoration: InputDecoration(
              labelText: TText.password, 
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
              ),
            )
          ),
        ), 
    
        const SizedBox(height: TSizes.spaceBtwInputFields),
    
        Row(
          children: [
            SizedBox(width:24, height: 24, child: Obx(() => Checkbox(value: controller.privacyPolicy.value, onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value))),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Text.rich(
              TextSpan(children: [
                TextSpan(text:'${TText.iAgreeTo} ', style: Theme.of(context).textTheme.bodySmall),
                TextSpan(text: '${TText.termsOfUse} ', style: Theme.of(context).textTheme.bodySmall!.apply(
                  color: TColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor:TColors.primary,
                )),
              ]),
            )
          ],
        ),
    
        const SizedBox(height: TSizes.spaceBtwInputFields),
        
        /// Sign up Button
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.signup(), child: const Text(TText.createAccount)),)
      ]),);
  }
}

void main() {
  runApp(const GetMaterialApp(
    home: SignupScreen(),
    ));
}