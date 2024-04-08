import 'dart:developer';
import 'dart:io';

void main() async {
  HttpServer server = await HttpServer.bind('127.0.0.1', 4040);
  log('Socket Server ON');

  await for (var request in server) {
    await WebSocketTransformer.upgrade(request).then((WebSocket socket) {
      log('Client Connected : ${request.connectionInfo!.remoteAddress.address}');
      socket.listen((data) {
        socket.add(data);
      });
    });
  }
}
