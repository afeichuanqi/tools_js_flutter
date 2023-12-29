import 'dart:isolate';

void runInIsolate(SendPort sendPort) {
  const message = 'This is from new Isolate';
  Future.delayed(const Duration(seconds: 3), () {
    sendPort.send(message);
  });
}

Future<void> main() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(runInIsolate, receivePort.sendPort);
  var str = await receivePort.first;
  receivePort.close;
  print(str);
}
