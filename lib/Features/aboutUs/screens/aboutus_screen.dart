import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/theme/theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AboutUsPage(),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    TAppTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us',style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
      child:Column(
        children: [
             const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to Maintenex, your trusted companion in vehicle maintenance and care. Our mission is to simplify the process of keeping your vehicle in top-notch condition, ensuring safety, reliability, and longevity.",
                    style: TextStyle(
                    fontSize: TSizes.fontSizeSm,                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Our Vision",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeMd, fontWeight: FontWeight.bold,                   ),
                  ),
                 Text(
                      "Here at Maintenex, we envision a world where every vehicle owner experiences the joy of hassle-free maintenance, leading to enhanced safety on the roads and significant savings in the long run.",
                      style: TextStyle(fontSize:TSizes.fontSizeSm,),
                      textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Who We Are",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeMd,fontWeight: FontWeight.bold,              ),
                  ),
                SizedBox(height: 20),
                  Text(
                      "We're a group of second-year students enrolled in BEng(Hons) Software Engineering degree program at the Informatics Institute of Technology (IIT), Sri Lanka, affliated with University of Westminster, UK.",
                      style:TextStyle(fontSize:TSizes.fontSizeSm,),
                      textAlign: TextAlign.justify,
                  ), 
                  SizedBox(height: 20),
                  Text(
                    "What Sets Us Apart.",
                    style: TextStyle(
                      fontSize: TSizes.fontSizeMd,fontWeight: FontWeight.bold,                    ),
                  ),
                  SizedBox(height: 20),
                    Text(
                      "Enjoy a seamless experience with an easy-to-navigate interface that puts essential information at your fingertips.From routine service reminders to tracking your vehicle's entire maintenance history, Maintenex offers a wide range of features to cater to all your automotive needs.",
                      style:TextStyle(fontSize:TSizes.fontSizeSm,),
                      textAlign: TextAlign.justify,
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                TImage.logoBlack,
              height: 120,
              width: 400,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      )
    );
  }
}
