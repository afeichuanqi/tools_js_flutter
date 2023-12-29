import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:post_tools/controllers/zhihu_search_controller.dart';
import 'package:post_tools/widgets/button_widget.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:intl/intl.dart';
import 'package:post_tools/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

var dio = Dio();

class MeiTuanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeiTuanPage();
}

class _MeiTuanPage extends State<MeiTuanPage>
    with AutomaticKeepAliveClientMixin {
  late ZhihuSearchController logic;
  // List<dynamic> ResponseJsons = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    logic = Get.put(ZhihuSearchController());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                var size = MediaQuery.of(context).size;
                // if (logic.responseJsons.value.length == 0) {
                //   return Center(child: Text("当前搜索条件无任何结果"));
                // }
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: InputSearchBar(
                        onSearch: onSearch,
                      ),
                    ),
                    logic.responseJsons.value.isEmpty
                        ? SliverToBoxAdapter(
                            child: Container(
                                width: size.width,
                                height: size.height - 100,
                                child: const Center(
                                    child: Text(
                                  "当前搜索条件无任何结果",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))))
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var item = logic.responseJsons.value[index];
                                var src = '';
                                if (item['object']['thumbnail_info']
                                            ['thumbnails']
                                        .isNotEmpty &&
                                    item['object']['thumbnail_info']
                                            ['thumbnails'][0]
                                        .containsKey('url')) {
                                  src = item['object']['thumbnail_info']
                                      ['thumbnails'][0]['url'];
                                }
                                var timestamp = item['object']
                                    ['updated_time']; // Unix 时间戳（秒级）
                                var date = DateTime.fromMillisecondsSinceEpoch(
                                    timestamp * 1000); // 转换为毫秒级
                                var formattedDate =
                                    DateFormat('yyyy年MM月dd日 HH点mm分ss秒')
                                        .format(date);
                                // 返回构建好的 Widget
                                return CardWidget(
                                  questionId:
                                      item['object']?['question']?['id'] ?? '',
                                  id: item['object']['id'],
                                  descText: item['object']['content'],
                                  timeText: formattedDate,
                                  title: item['object']['title'],
                                  src: src,
                                  voteupCount: item['object']['voteup_count'],
                                  commentCount: item['object']['comment_count'],
                                  constraints:
                                      constraints, // 添加回 constraints 参数
                                );
                              },
                              childCount:
                                  logic.responseJsons.value.length, // 设置子项的数量
                            ),
                          ),
                  ],
                );
              });
            },
          ),
        ),
        FullScreenLoading(loading: isLoading)
      ],
    );
  }

  void onSearch(content) async {
    setState(() {
      isLoading = true;
    });
    var response;
    try {
      // 要发送的数据
      var postData = jsonEncode({
        'code': 'c4ca4238a0b923820dcc509a6f75849b',
        'd_c0': 'AHAS7RemQxePTtkbrdr4Hcz1MV-RRdsdB6c=|1692456825',
        'url':
            '/api/v4/search_v3?gk_version=gz-gaokao&t=general&q=${Uri.encodeComponent(content)}&correction=1&offset=0&limit=20&filter_fields=&lc_idx=0&show_all_topics=0&search_source=Normal',
        // 其他键值对
      });
      String Cookie =
          '_zap=88d77bbe-fa09-4ff4-9e63-2d0681858fa6; d_c0=AHAS7RemQxePTtkbrdr4Hcz1MV-RRdsdB6c=|1692456825; __snaker__id=dTEWxDPzAx7oNK5T; YD00517437729195%3AWM_TID=6pyaLbg1OxhEQRARUBLU34ikOjEUDCel; YD00517437729195%3AWM_NI=U5%2BRzbB0YRfD4JZwb6zD1SaamXXIpW%2BPLnFdwdKoCyfD7Y1WvIWt22N7ahN9lrUZpbPKdMr8ECB1Ej2Aknv%2FvR8NOUEDmH3mih6tisyD%2BdG9yOVUuWKHHJvZ7OWkABmdSGw%3D; YD00517437729195%3AWM_NIKE=9ca17ae2e6ffcda170e2e6eeaaf76697ba8996f250f4928ea6d15e968b8f82d862b693fad1c97eaf8cbed6ae2af0fea7c3b92a97ebe5b3f96a82f097b3e550f8969698e13eba9cffb4e46baf8898aaf35de990848fc570b5bc8590c273a69cf9bab45db6979995b13a8ee9af89cd33b0ae9bbbf36a9495acaef134879d8ed2c862f29fa58ff525b68ef8afce5f879ca3a9b267abb8fa95ec79bb9ce585c633bb919ab6f85d899888abf552f591998cc44aafbc9da8f637e2a3; q_c1=48a2c09a01f2428abe06bd24a2e64545|1700128363000|1700128363000; _xsrf=c6d9ac21-6e26-4a8a-b49c-8aebaa1b5af7; SESSIONID=Cp5WyZOEaMkwB8C9jyivVxpEojquEKh8o4JwXCAODhJ; JOID=U1wQC018zg9DVelPXXVsWtP90OZOOr83Giu2ARUahmU5GdYJZSjsdy9X7UNeqqDuhsRh2Eo7ZrsB-dFIV1bqmns=; osd=UlgRAEJ9yg5IWuhLXH5jW9f82-lPPr48FSqyAB4Vh2E4EtkIYSnneC5T7EhRq6Tvjctg3EswaboF-NpHVlLrkXQ=; captcha_session_v2=2|1:0|10:1702571615|18:captcha_session_v2|88:MWg0b25JTExObFJwSk11RVlPanBpcmJQUDZOU05wamNQN1dwWEYrL2hlVHdlZWVXNVhKTDFLM3c1bTdvZlNXdg==|25330edbe024096f62ecbd868aba573a7d3df8e85a4e78ebf0d17466bf7d28ae; gdxidpyhxdE=7jkqBfS3aIo%2F0AsvaCVsMU5jpBB7q2qRNNYV3tJON2gkRcdnR8fQ8wrsrQQXttjBYGLrQHUZCZ8umRRcMmKbSOUpiVPIcOL7dYzE7H%2FAaLRao%5Cb24yWE1wVjNH0LHd%5C%2Fvhy4fwusolD5NZetwQC9XIOrGbb8p8gKmD9dQy0BRtAgZhy%5C%3A1702572516272; captcha_ticket_v2=2|1:0|10:1702571635|17:captcha_ticket_v2|728:eyJ2YWxpZGF0ZSI6IkNOMzFfTHhFSnlQQzRYYUQ5QlZ6TjJtVkJUU0RaVDZ4VnR3WXVlR3NPTGh5RlhjNEIyX3ZzNVdvajlTSVhoekEwdHdzVS5PM3VqUUdiSThQdnJyQyo5OEpsVDJnZXVJa3lEX0lWZGEzYTNSa1lydU9MM3NhVF8ub2FiU2x2eUVmVzJVRmVVSXFkSXE5a0lTam1oand0dkpLRlVIbHJqSnRiUUpGblE0Unp4NE1KUEhwcDZWSzBYcEJibzlidUlKdW9MWTZ5TFpYSVJXWVg4cnJPOVVuZEJfYzFUdzhOa1pZVUhZdWswYXdWSWRtZ0hYbWdmRDROU0YzTk94UlIzcWZFTGF4c0pjKlpYdXlTWkduOUVpMWJDcEpQNE1jaipIWVlQdUNyeUdvSipBX2NHV2RhanM0cnU5Q2cydWRyMDh1eTBnUG5mUmtBbkdBYWtmNk14QmtTRnU1SVJnVXhQdUlTS3ZaYV9iX0RCUkdOamJLUDBybWh1LndLcVRHTWNkMXJCYWxyU2ltQ0JaMzRDOWRBSjJMaWlRMXVHa3hYUHBYWVdkYXZidFZta1ZvUTNjY2VBdWpRMkRNbyo2MG5rbzV0TmVLX0ZmUzV2bU4qbzRuMWVXZjRpKnV4eTBkZWwzalpnaVVBOVQ1NVZQdXUyMGFSaUZCU2VIUHRqMHpUbUY1VWVGUXVOQUpsaE03N192X2lfMSJ9|1b8f03ceaca4e0c62728408bf3646763ba9ecc4f572a2528ec27fe94b8aa5b7f; tst=r; z_c0=2|1:0|10:1702571666|4:z_c0|92:Mi4xNWJyZ1RRQUFBQUFBY0JMdEY2WkRGeVlBQUFCZ0FsVk5qM3hvWmdCUjh5Q1lIMjVMcmt4a0RBbWcxZVhTR1QwdkNB|5d016465faa9c6366fafaaa465fe35af00bfa727022cd02cc5c0f0ffcee23917; KLBRSID=0a401b23e8a71b70de2f4b37f5b4e379|1702571678|1702561952';
      response = await dio.post('http://101.35.247.151:3000/getParams',
          options: Options(
              contentType:
                  Headers.jsonContentType, // 设置内容类型为 x-www-form-urlencoded
              headers: {"Cookie": Cookie}),
          data: postData);
      var zes96 = response.data['result'];
      var headers = {
        'authority': 'www.zhihu.com',
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7',
        'cache-control': 'no-cache',
        'cookie': Cookie,
        'pragma': 'no-cache',
        'referer':
            'https://www.zhihu.com/search?type=content&q=${Uri.encodeComponent(content)}',
        'sec-ch-ua':
            '"Google Chrome";v="119", "Chromium";v="119", "Not?A_Brand";v="24"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Windows"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
        'x-api-version': '3.0.91',
        'x-app-za': 'OS=Web',
        'x-requested-with': 'fetch',
        'x-zse-93': '101_3_3.0',
        'x-zse-96': '2.0_${zes96}',
      };
      response = await dio.request(
        'https://www.zhihu.com/api/v4/search_v3?gk_version=gz-gaokao&t=general&q=${Uri.encodeComponent(content)}&correction=1&offset=0&limit=20&filter_fields=&lc_idx=0&show_all_topics=0&search_source=Normal',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var newDatas = response.data['data']
            .where((item) =>
                item.containsKey('object') &&
                item['object'] is Map &&
                item['object'].containsKey('title') &&
                item.containsKey('object') &&
                item['object'] is Map &&
                item['object'].containsKey('thumbnail_info') &&
                item['object']['thumbnail_info'] is Map &&
                item['object']['thumbnail_info'].containsKey('thumbnails'))
            .toList();
        logic.updateResponseJsons(newDatas);
        // setState(() {
        //   ResponseJsons = newDatas;
        // });
      }
    } catch (e) {
      logic.updateResponseJsons([]);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class InputSearchBar extends StatefulWidget {
  final void Function(String content) onSearch;
  const InputSearchBar({
    super.key,
    required this.onSearch,
  });
  @override
  State<StatefulWidget> createState() {
    return _InputSearchBar();
  }
}

class _InputSearchBar extends State<InputSearchBar> {
  double opacity = 1;
  late ZhihuSearchController logic;
  late TextEditingController textEditingController;
  void initState() {
    super.initState();
    textEditingController =
        Get.find<ZhihuSearchController>().textEditingController;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          const Text(
            "搜索知乎内容：",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: SizedBox(
            height: 30,
            child: TextField(
              onSubmitted: (value) {
                widget.onSearch(value);
              },
              controller: textEditingController,
              minLines: 1,
              style: TextStyle(fontSize: 14),
              maxLines: 1, // 允许无限行
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(5), // 增加垂直内边距
                hintText: '请输入知乎内容',
                border: OutlineInputBorder(), // 添加边框
              ),
            ),
          )),
          GestureDetector(
            onTap: () {
              widget.onSearch(textEditingController.text);
            },
            child: MouseRegion(
              onEnter: (event) {
                setState(() {
                  opacity = 0.7;
                });
              },
              onExit: (event) {
                setState(() {
                  opacity = 1;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(opacity),
                    borderRadius: BorderRadius.circular(5)),
                child: const Center(
                  child: Text(
                    "搜索",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final BoxConstraints constraints;
  late OverlayEntry overlayEntry;
  final String title;

  final String src;
  final String timeText;
  final String descText;
  final String id;
  final num voteupCount;
  final num commentCount;
  final dynamic questionId;
  @override
  CardWidget({
    super.key,
    required this.title,
    required this.constraints,
    required this.src,
    required this.timeText,
    required this.descText,
    required this.voteupCount,
    required this.commentCount,
    required this.id,
    this.questionId,
  });

  @override
  State<StatefulWidget> createState() {
    return _CardWidget();
  }
}

class _CardWidget extends State<CardWidget> {
  bool isOverlayRemove = false;
  double opacity = 1;
  TextEditingController textController = TextEditingController();
  void openZhihuUrl() async {
    var url = 'https://zhuanlan.zhihu.com/p/${widget.id.toString()}';
    print(widget.questionId);
    if (widget.questionId != '') {
      url =
          'https://www.zhihu.com/question/${widget.questionId.toString()}/answer/${widget.id.toString()}';
    } else {
      url = 'https://zhuanlan.zhihu.com/p/${widget.id.toString()}';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '无法打开 $url';
    }
  }

  void showFullScreenOverlay(BuildContext context) {
    textController.text = "";
    isOverlayRemove = false;
    widget.overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          if (!isOverlayRemove) {
            widget.overlayEntry.remove(); // 3秒后自动移除弹窗
            isOverlayRemove = true;
          }
        },
        child: Material(
          color: Colors.black.withOpacity(0.5), // 设置半透明的黑色背景
          child: Container(
            width: double.infinity, // 宽度占满屏幕
            height: double.infinity, // 高度占满屏幕
            alignment: Alignment.center,
            child: Center(
              child: Container(
                width: 400, // 根据需要调整宽度
                height: 300, // 根据需要调整高度
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "请输入评论内容:",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: 200,
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: textController,
                          minLines: 8,
                          style: const TextStyle(fontSize: 14),
                          maxLines: null, // 允许无限行
                          keyboardType: TextInputType.multiline, // 多行文本输入
                          decoration: const InputDecoration(
                            hintText: '请输入评论内容',
                            border: OutlineInputBorder(), // 添加边框
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isOverlayRemove) {
                          widget.overlayEntry.remove();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            width: 50,
                            height: 30,
                            child: const Center(
                              child: Text(
                                "提交",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // 在 Overlay 中显示我们的自定义 OverlayEntry
    Overlay.of(context)!.insert(widget.overlayEntry);
    // 可以设置一个手动关闭按钮或者其他逻辑来移除弹窗
    // 可以设置一个延时来自动关闭弹窗
    // Future.delayed(Duration(seconds: 2), () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 3.0, color: Colors.green),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                openZhihuUrl();
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
                child: SizedBox(
                  width: size.width - 50,
                  child: MouseRegion(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.title,
                          size: 20,
                          color: Colors.green.withOpacity(opacity),
                        ),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                color: Colors.black.withOpacity(opacity),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(widget.timeText)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: const Icon(
                          Icons.format_bold,
                          size: 20,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          child: SingleChildScrollView(
                            child: Text(widget.descText),
                          ),
                        ),
                      )
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 100,
                    child: widget.src.length == 0
                        ? Image.asset(
                            'assets/images/js.webp',
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            widget.src,
                            fit: BoxFit.contain,
                          ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        showFullScreenOverlay(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.thumb_up,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.voteupCount.toString()} 赞同',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        showFullScreenOverlay(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.question_answer,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.commentCount.toString()}条评论',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
