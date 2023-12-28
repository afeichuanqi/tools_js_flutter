import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_tools/pages/home_page.dart';
import 'package:post_tools/pages/info_page.dart';
import 'package:post_tools/pages/zhihu_search_page.dart';
import 'package:post_tools/widgets/menu_item.dart';

class GlobalLayout extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: '1');

  GlobalLayout({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _GlobalLayout();
  }
}

class _GlobalLayout extends State<GlobalLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  ScrollController _scrollController = ScrollController();

  bool isClose = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween(begin: 200.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧边栏
                  AnimatedBuilder(
                    animation: _widthAnimation,
                    builder: (context, child) {
                      return Container(
                        width: _widthAnimation.value, // 动画宽度
                        height: constraints.maxHeight,
                        color: const Color.fromARGB(255, 48, 65, 86), // 自定义颜色
                        child: Stack(
                          clipBehavior: Clip.none, // 允许子控件溢出 Stack 的边界
                          children: [
                            Scrollbar(
                              controller: _scrollController,
                              trackVisibility: true,
                              thickness: 10.0, // 设置滚动条的厚度
                              radius: Radius.circular(10), // 设置滚动条的圆角
                              scrollbarOrientation: ScrollbarOrientation.right,
                              child: ListView(
                                controller: _scrollController,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: LogoWidget(
                                      parentWidth: _widthAnimation.value,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: MenuItemWidgetState(
                                      onActiveItemChange: (name) {
                                        Get.toNamed(
                                          "/${name}",
                                          id: 1,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // 右侧页面容器
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Navigator(
                        key: Get.nestedKey(1), // 使用独立的GlobalKey
                        onGenerateRoute: (settings) {
                          return PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              // 根据路由名称返回不同的页面
                              switch (settings.name) {
                                case '/home':
                                  return HomePage();
                                case '/my':
                                  return InfoPage();
                                case '/meituan':
                                  return MeiTuanPage();
                                default:
                                  return HomePage();
                              }
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                            transitionDuration: Duration(milliseconds: 300),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _widthAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: _widthAnimation.value,
                    top: constraints.maxHeight / 2 - 25,
                    child: PositionedLeftAction(
                      isClose: isClose,
                      onTap: () {
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                        setState(() {
                          isClose = !isClose;
                        });
                      },
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _widthAnimation,
                builder: (context, child) {
                  return Positioned(
                      bottom: 0,
                      left: _widthAnimation.value - 200,
                      child: BottomContainerInfo());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class PositionedLeftAction extends StatefulWidget {
  final void Function()? onTap;
  final bool isClose;
  const PositionedLeftAction({
    super.key,
    this.onTap,
    required this.isClose,
  });

  @override
  State<StatefulWidget> createState() {
    return _PositionedLeftAction();
  }
}

class _PositionedLeftAction extends State<PositionedLeftAction> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (event) => setState(() {
          hovered = false;
        }),
        child: Container(
          width: 25,
          height: 50,
          color: Color.fromRGBO(255, 255, 255, hovered ? 30 : 125),
          child: Center(
            child: Icon(
              widget.isClose ? Icons.arrow_right : Icons.arrow_left,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomContainerInfo extends StatelessWidget {
  const BottomContainerInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 0, 21, 40)),
      height: 40,
      width: 200,
      child: const Center(
        child: Text(
          '版权所有 V1.0',
          style: TextStyle(
              fontSize: 15,
              decoration: TextDecoration.none,
              color: Colors.white),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double parentWidth;
  const LogoWidget({
    super.key,
    required this.parentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
            width: 45,
            height: 20,
            child: Image.asset(
              'assets/images/js.webp',
              fit: BoxFit.fill,
            )),
        const SizedBox(
          width: 5,
        ),
        const Text(
          "JS DEBUGGER",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              color: Colors.white),
        )
      ],
    );
  }
}
