import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZhihuSearchController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  var responseJsons = Rx<List<dynamic>>([]);

  // 添加用于更新 responseJsons 的方法
  void updateResponseJsons(List<dynamic> newJsons) {
    responseJsons.value = newJsons; // 更新值
  }
}
