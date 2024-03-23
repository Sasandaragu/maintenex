import 'package:flutter/material.dart';
import 'package:maintenex/utils/constants/colors.dart';
import 'package:maintenex/utils/constants/sizes.dart';

class MCircularImage extends StatelessWidget {
  const MCircularImage ({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build (BuildContext context) {
    return Container (
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color:TColors.white,
        borderRadius: BorderRadius.circular (100),
    ), // BoxDecoration

      child: Center (
        child: Image (
        fit: fit,
        image: isNetworkImage? NetworkImage (image): AssetImage (image) as ImageProvider,
        color: overlayColor,
        ), 
      ),
    ); 
  }
}