import 'package:flutter/material.dart';
import 'package:flutter_sharing_app/pages/reciever.dart';
import 'package:flutter_sharing_app/pages/sender.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Share")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Send File"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SendPage()));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Receive File"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReceivePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
