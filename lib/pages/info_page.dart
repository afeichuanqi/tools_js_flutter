import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoPage extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InfoPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  late Worker _worker; // 用于取消监听
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    // 设置路由监听器
    // 监听路由变化
    // Get.find<RouteObserver<PageRoute<dynamic>>>().subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // print("应用不在前台");
    } else if (state == AppLifecycleState.resumed) {
      // print("应用回到前台");
    }
    // 其他状态：inactive、detached
  }

  @override
  void dispose() {
    // 移除路由监听器
    WidgetsBinding.instance!.removeObserver(this);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final size = MediaQuery.of(context).size;
          double value = controller.value * 2 * pi;
          double radius = 200;
          double x = (size.width - 250) / 2 + radius * cos(value);
          double y = (size.height / 2) - 40 + radius * sin(value);
          return Stack(
            children: [
              Positioned(
                left: x,
                top: y,
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red,
                ),
              ),
              Positioned(
                  top: size.height / 2 - 40,
                  left: (size.width - 250) / 2,
                  child: const Text(
                    "by JS",
                    style: TextStyle(fontSize: 40, color: Colors.blue),
                  ))
            ],
          );
        },
      ),
    );
  }
}
