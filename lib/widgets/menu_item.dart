import 'package:flutter/material.dart';

class MenuItemWidgetState extends StatefulWidget {
  final Function(dynamic) onActiveItemChange;
  MenuItemWidgetState({required this.onActiveItemChange});
  @override
  State<StatefulWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidgetState> {
  String activeKey = '';
  late List<String> dataList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataList = List.filled(12, '1').map((item) => 'Your logic here').toList();
  }

  @override
  Widget build(BuildContext context) {
    void _onActiveItemChange(String name) {
      widget.onActiveItemChange.call(name);
    }

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 40),
      child: Column(
        children: [
          // ...dataList.asMap().entries.map((item) {
          //   return MenuItemWidget(
          //     title: item.key.toString(),
          //     icon: Icons.javascript,
          //     actived: activeKey == item.key.toString(),
          //     onTap: () {
          //       setState(() {
          //         activeKey = item.key.toString();
          //       });
          //       _onActiveItemChange(item.key.toString());
          //     },
          //   );
          // }).toList(),
          MenuItemWidget(
            title: "JS运行",
            icon: Icons.soup_kitchen,
            actived: activeKey == "home",
            onTap: () {
              setState(() {
                activeKey = "home";
              });
              _onActiveItemChange('home');
            },
          ),
          MenuItemWidget(
            title: "知乎搜索",
            actived: activeKey == "meituan",
            icon: Icons.search,
            onTap: () {
              setState(() {
                activeKey = "meituan";
              });
              _onActiveItemChange('meituan');
            },
          ),
          MenuItemWidget(
            title: "备注",
            actived: activeKey == "my",
            icon: Icons.info,
            onTap: () {
              setState(() {
                activeKey = "my";
              });
              _onActiveItemChange('my');
            },
          ),
        ],
      ),
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool actived;
  final void Function() onTap;
  const MenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.actived,
  });

  @override
  State<StatefulWidget> createState() {
    return _menuItemWidget();
  }
}

class _menuItemWidget extends State<MenuItemWidget> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap.call();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: (hovered || widget.actived)
                ? Color.fromARGB(255, 0, 21, 40)
                : Color.fromARGB(255, 48, 65, 86),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 15,
              ),
              Icon(
                // 64, 158, 255
                widget.icon,
                size: 16,
                color: widget.actived
                    ? Color.fromRGBO(64, 158, 255, 1)
                    : Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  color: widget.actived
                      ? Color.fromRGBO(64, 158, 255, 1)
                      : Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
