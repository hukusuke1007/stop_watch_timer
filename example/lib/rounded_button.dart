import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.child,
    this.color,
    this.disableColor,
    this.elevation,
    this.side = BorderSide.none,
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? color;
  final Color? disableColor;
  final double? elevation;
  final BorderSide side;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: const StadiumBorder().copyWith(side: side),
        disabledBackgroundColor: disableColor ?? Colors.grey,
        elevation: elevation,
      ),
      onPressed: onTap,
      child: child,
    );
  }
}
