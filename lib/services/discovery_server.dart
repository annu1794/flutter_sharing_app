// discovery_server.dart
import 'dart:io';
import 'dart:convert';

class DiscoveryServer {
  static Future<void> startDiscoveryResponder(int port) async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then((socket) {
      print("Discovery Server listening on port $port");

      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            final message = utf8.decode(datagram.data);
            if (message == "DISCOVER_REQUEST") {
              final response = "DISCOVER_RESPONSE:${datagram.address.address}";
              socket.send(
                utf8.encode(response),
                datagram.address,
                datagram.port,
              );
              print("Responded to discovery from ${datagram.address}");
            }
          }
        }
      });
    });
  }
}
