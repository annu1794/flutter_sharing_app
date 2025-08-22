import 'dart:convert';
import 'dart:io';
import 'dart:async';

class TransferClient {
  static Future<void> sendFile(
      File file,
      String receiverIp,
      int port, {
        required Function(double) onProgress,
      }) async {
    final socket = await Socket.connect(receiverIp, port);
    print("📤 Connected to $receiverIp:$port");

    // First send filename
    final fileName = file.uri.pathSegments.last;
    socket.add(fileName.codeUnits);

    // Then send file data
    final fileStream = file.openRead();
    final totalBytes = await file.length();
    int sentBytes = 0;

    final completer = Completer<void>();

    fileStream.listen(
          (data) {
        socket.add(data);
        sentBytes += data.length;
        onProgress(sentBytes / totalBytes);
      },
      onDone: () {
        print("✅ File transfer complete");
        socket.destroy();
        completer.complete();
      },
      onError: (err) {
        print("❌ Error: $err");
        socket.destroy();
        completer.completeError(err);
      },
    );

    return completer.future;
  }
}


class TransferServer {
  static Future<String> startServer(
      {required int port, required Function(double) onProgress}) async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print("Server listening on port $port");

    final socket = await server.first;

    // Read header
    final headerLine = await utf8.decoder.bind(socket).transform(const LineSplitter()).first;
    final header = jsonDecode(headerLine);
    final fileName = header["fileName"];
    final fileSize = header["fileSize"];

    final file = File("/storage/emulated/0/Download/$fileName"); // save in Downloads
    final sink = file.openWrite();

    int received = 0;
    await for (var chunk in socket) {
      sink.add(chunk);
      received += chunk.length;
      onProgress(received / fileSize);
    }

    await sink.close();
    await server.close();

    return file.path;
  }
}
