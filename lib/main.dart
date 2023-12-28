import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_tools/layout/global_layouts.dart';
import 'package:post_tools/pages/home_page.dart';
import 'package:post_tools/pages/info_page.dart';

// 其他必要的页面导入
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: null, // 使用您自定义的字体
      ),
      title: '工具',
      // initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/my', page: () => InfoPage()),
        // 定义其他页面的路由
      ],
      home: GlobalLayout(),
    );
  }
}
