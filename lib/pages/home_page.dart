import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_tools/controllers/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/json.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

final controller = CodeController(
  text: '', // Initial code
  language: javascript,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

var controller1 = CodeController(
  text: '', // Initial code
  language: json,
);

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin {
  late HomePageController logic;
  late JavascriptRuntime flutterJs = getJavascriptRuntime();

  @override
  void initState() {
    super.initState();
    logic = Get.put(HomePageController()); // 或使用 Get.find() 如果已经创建
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 不要忘记这个
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = MediaQuery.of(context).size;
              return Column(children: [
                CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: SizedBox(
                    height: 400,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: CodeField(
                        minLines: 15,
                        controller: controller,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Color.fromARGB(255, 69, 69, 83),
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtomWidget(
                          title: "清空",
                          onTap: () {
                            controller.text = '';
                            controller1.text = '';
                          },
                        ),
                        ButtomWidget(
                          title: "加载",
                          onTap: () {
                            var code = controller.code.text.toString();
                            flutterJs.dispose();
                            flutterJs.init();
                            JsEvalResult jsResult = flutterJs.evaluate(code);
                            controller1.text = jsResult.toString();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: SizedBox(
                    height: size.height - 430 - 60,
                    child: SingleChildScrollView(
                      child: CodeField(
                        minLines: 20,
                        controller: controller1,
                      ),
                    ),
                  ),
                )
              ]);
            },
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true; // 保持页面状态
}

class ButtomWidget extends StatefulWidget {
  final String title;
  final void Function()? onTap;
  const ButtomWidget({super.key, required this.title, this.onTap});
  @override
  State<StatefulWidget> createState() {
    return _ButtomWidget();
  }
}

class _ButtomWidget extends State<ButtomWidget> {
  double opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            opacity = 0.6;
          });
        },
        onExit: (event) {
          setState(() {
            opacity = 1.0;
          });
        },
        child: Container(
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              // 33,150,243
              //33, 150, 243
              color: Color.fromRGBO(33, 150, 243, opacity),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            child: Text(
              widget.title,
              style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 13,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
