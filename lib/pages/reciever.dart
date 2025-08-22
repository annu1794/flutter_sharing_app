
import 'package:flutter/material.dart';
import '../services/discovery_server.dart';
import '../services/transfer_server_client.dart';
import '../widgets/progress_bar.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  double progress = 0.0;
  bool isReceiving = false;
  String? savedPath;

  @override
  void initState() {
    super.initState();
    DiscoveryServer.startDiscoveryResponder(4040); // UDP discovery port
    TransferServer.startServer(
      port: 5000,
      onProgress: (p) {
        setState(() => progress = p);
      },
    );// file server
  }

  Future<void> startServer() async {
    setState(() {
      isReceiving = true;
      progress = 0.0;
    });

    String path = await TransferServer.startServer(
      port: 5000,
      onProgress: (p) {
        setState(() => progress = p);
      },
    );

    setState(() {
      savedPath = path;
      isReceiving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("File received: $path")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receive File")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.wifi_tethering),
              label: const Text("Start Receiver"),
              onPressed: startServer,
            ),
            const SizedBox(height: 20),

            if (isReceiving) ProgressBar(value: progress),

            if (savedPath != null) Text("Saved at: $savedPath"),
          ],
        ),
      ),
    );
  }
}
