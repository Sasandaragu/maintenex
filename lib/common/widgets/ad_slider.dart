import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class AdSlider extends StatelessWidget {
  const AdSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0, 
        autoPlay: true, // Enabling auto-play mode
        autoPlayInterval: const Duration(seconds: 5), // Setting the auto-play interval for each ad
        enlargeCenterPage: true,
      ),
      items: const [
        // Displaying ads
        AdWidget(imageUrl: 'assets/images/onboarding/Onboarding1.png'),
        AdWidget(imageUrl: 'assets/images/onboarding/Onboarding2.png'),
        AdWidget(imageUrl: 'assets/images/onboarding/Onboarding3.png'),
     
      ],
    );
  }
}

class AdWidget extends StatelessWidget {
  final String imageUrl;

  const AdWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
