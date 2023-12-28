import 'package:webview_dart/webview_dart.dart';

void main() {
  final url = "https://www.google.com";
  Webview(true)
      .setTitle("title")
      .setSize(1280, 800, SizeHint.none)
      .navigate(url)
      .run();
}
