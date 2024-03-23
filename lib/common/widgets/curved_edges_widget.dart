import 'package:flutter/widgets.dart';
import 'package:maintenex/common/widgets/curved_edges.dart';

class TCurvedEdgesWidget extends StatelessWidget {
  const TCurvedEdgesWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build (BuildContext context) {
    return ClipPath(
      clipper: TCustomCurvedEdges (),
      child: child,
    ); 
  }
}