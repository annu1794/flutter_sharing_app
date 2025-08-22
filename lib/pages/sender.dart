import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/discovery_client.dart';
import '../services/transfer_server_client.dart';
import '../widgets/file_tile.dart';
import '../widgets/progress_bar.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  File? selectedFile;
  double progress = 0.0;
  bool isSending = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send File")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.file_present),
              label: const Text("Pick File"),
              onPressed: pickFile,
            ),
            const SizedBox(height: 20),

            if (selectedFile != null) FileTile(file: selectedFile!),
            const SizedBox(height: 20),

            if (isSending) ProgressBar(value: progress),

            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Send"),
              onPressed: () async {
                DiscoveryClient.startDiscoveryResponder(4444);
                final devices = await DiscoveryClient.discoverDevices(4444);
                print("Discovered Devices: $devices");

                if (devices.isNotEmpty && selectedFile != null) {
                  // Send file to first discovered device
                  await TransferClient.sendFile(
                    selectedFile!,
                    devices.first, // receiver IP
                    5000,
                    onProgress: (progressValue) {
                      setState(() {
                        progress = progressValue; // already a fraction 0..1
                      });
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
