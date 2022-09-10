import 'package:flutter/material.dart';

class GenericCardComponent extends StatelessWidget {
  final double borderRadius;
  final Color backgroundColor;
  final Widget child;

  const GenericCardComponent({
    Key key,
    this.child,
    this.borderRadius,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor ?? Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(1, 2),
              color: Colors.black26,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ]),
      child: child,
    );
  }
}
