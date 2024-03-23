import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:maintenex/Features/authentication/controllers/login/login_controller.dart';
import 'package:maintenex/Features/authentication/screens/forget_password/forget_password.dart';
import 'package:maintenex/common/styles/spacing_styles.dart';
import 'package:maintenex/features/authentication/screens/signup/signup.dart';
import 'package:maintenex/utils/constants/colors.dart';
import 'package:maintenex/utils/constants/image_strings.dart';
import 'package:maintenex/utils/constants/sizes.dart';
import 'package:maintenex/utils/constants/text_strings.dart';
import 'package:maintenex/utils/validators/validation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              TLoginHeader(),

              TLoginForm(),

              //divider
              //TFormDivider(dividerText: TText.orSignInWith),

              // SizedBox(height:TSizes.spaceBtwSections),

              // TSocialButtons(),
            ],
          ),
          ),
        ),
    );
  }
}

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: TColors.grey),borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){},
            icon: const Image(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              image: AssetImage(TImage.google),
            )
          ),
        ),
    
        const SizedBox(width:TSizes.spaceBtwItems),
    
        Container(
          decoration: BoxDecoration(border: Border.all(color: TColors.grey),borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){},
            icon: const Image(
              width: TSizes.iconMd,
              height: TSizes.iconMd,
              image: AssetImage(TImage.facebook),
            )
          ),
        ),
      ],
    );
  }
}

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key, required String dividerText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(child: Divider(color: TColors.grey,thickness: 0.5,indent: 60,endIndent: 5)),
        Text(TText.orSignInWith,style: Theme.of(context).textTheme.labelMedium),
        const Flexible(child: Divider(color: TColors.grey,thickness: 0.5,indent: 5,endIndent: 60)),
      ],
    );
  }
}

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child:Padding(padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
      child: Column(
      children: [
        const SizedBox(height: TSizes.spaceBtwSections),
        //Email
        TextFormField(
          controller: controller.email,
          validator: (value) => MValidator.validateEmail(value),
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: TText.email),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
    
        ///Password
        Obx(
          () => TextFormField(
            controller: controller.password,
            validator: (value) => MValidator.validateEmptyText('Password', value),
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
    
        ///Remember Me & Forget Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children:[
                //Remember Me
                Obx(() => Checkbox(value: controller.remenberMe.value, onChanged: (value) => controller.remenberMe.value = !controller.remenberMe.value)),
                const Text(TText.rememberMe),
              ],
            ),
    
            //Forget Password
            TextButton(onPressed: () => Get.to(() =>const ForgetPassword()), child: const Text(TText.forgetPassword)),
          ],
        ),
        const SizedBox(height:TSizes.spaceBtwInputFields),
    
        //Sign In button
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text(TText.signIn))),
    
        const SizedBox(height:TSizes.spaceBtwItems),
    
        //Create Account Button
        SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Get.to(() =>const SignupScreen()), child: const Text(TText.createAccount))),
      ],
      )),
    );
  }
}

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Image(
          height: 150,
          image:AssetImage(TImage.logo),
        ),
        Text(TText.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.sm),
        Text(TText.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
    );
  }
}

void main() {
  runApp(const GetMaterialApp(
    home: LoginScreen(),
    ));
}