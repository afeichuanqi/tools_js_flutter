import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final void Function()? onClick;
  final Widget child;
  CustomButton({super.key, this.onClick, required this.child});
  @override
  State<StatefulWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButton> {
  double opacity = 1;
  @override
  Widget build(BuildContext context) {
    print(widget.child);
    return GestureDetector(
      onTap: () {
        widget.onClick?.call();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            opacity = 0.5;
          });
        },
        onExit: (event) {
          setState(() {
            opacity = 1;
          });
        },
        child: Container(
            child: widget.child,
            color: Colors.transparent.withOpacity(opacity)),
      ),
    );
  }
}
