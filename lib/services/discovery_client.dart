// discovery_client.dart
import 'dart:io';
import 'dart:convert';

import 'package:network_info_plus/network_info_plus.dart';

class DiscoveryClient {


  // Run this on every device that should be discoverable
  static Future<void> startDiscoveryResponder(int port) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          final msg = utf8.decode(datagram.data);
          if (msg == "DISCOVER_REQUEST") {
            // Reply with own IP
            final ip = socket.address.address;
            final response = utf8.encode("DISCOVER_RESPONSE:$ip");
            socket.send(response, datagram.address, datagram.port);
          }
        }
      }
    });
  }


  static Future<List<String>> discoverDevices(int port,
      {Duration timeout = const Duration(seconds: 3)}) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;

    final devices = <String>[];
    final request = utf8.encode("DISCOVER_REQUEST");

    // Use broadcast
    socket.send(request, InternetAddress("255.255.255.255"), port);

    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          final msg = utf8.decode(datagram.data);
          if (msg.startsWith("DISCOVER_RESPONSE:")) {
            final ip = msg.split(":")[1];
            if (!devices.contains(ip)) devices.add(ip);
          }
        }
      }
    });

    await Future.delayed(timeout);
    socket.close();
    return devices;
  }

}
