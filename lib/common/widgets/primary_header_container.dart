import 'package:flutter/widgets.dart';
import 'package:maintenex/common/widgets/circular_container.dart';
import 'package:maintenex/common/widgets/curved_edges_widget.dart';
import 'package:maintenex/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build (BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container (
        color: TColors.primary,
      
        /// -- [size.isFinite': is not true] Error -> Read README.md file at [DESIGN ERRORS] # 1
        child: Stack(
          children: [
            
            Positioned (top: -150, right: -250, child: TCircularContainer (backgroundColor: TColors.textWhite.withOpacity (0.1))),
            Positioned (top: 100, right: -300, child: TCircularContainer (backgroundColor: TColors.textWhite.withOpacity (0.1))),
            child,
          ],
        ), 
      ), 
    ); 
  }
}