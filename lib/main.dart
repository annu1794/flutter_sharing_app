import 'package:flutter/material.dart';
import 'package:flutter_sharing_app/pages/homepage.dart';
import 'package:flutter_sharing_app/services/discovery_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Start responder on a fixed port (must be same across devices)
  DiscoveryClient.startDiscoveryResponder(4444);

  runApp(const FileShareApp());
}

class FileShareApp extends StatelessWidget {
  const FileShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "File Share",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
