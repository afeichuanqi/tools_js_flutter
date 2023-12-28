import 'package:flutter/material.dart';

class FullScreenLoading extends StatefulWidget {
  final bool loading;

  FullScreenLoading({required this.loading});

  @override
  _FullScreenLoadingState createState() => _FullScreenLoadingState();
}

class _FullScreenLoadingState extends State<FullScreenLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FullScreenLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading) {
      _controller..repeat();
    } else {
      _controller..stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? Container(
            color: Colors.black.withOpacity(0.5), // 半透明背景
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _controller,
                    child: const Icon(
                      Icons.sync,
                      size: 30,
                      color: Colors.white,
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: _controller.value * 2.0 * 3.1415926535897932,
                        child: child,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text("加载中", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          )
        : const SizedBox.shrink(); // 如果不是加载状态，返回一个空的 SizedBox
  }
}
