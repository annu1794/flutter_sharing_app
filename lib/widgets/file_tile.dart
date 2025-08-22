// lib/widgets/file_tile.dart
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;


class FileTile extends StatelessWidget {
  final File file;
  const FileTile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file),
      title: Text(file.path.split('/').last),
      subtitle: Text("${file.lengthSync()} bytes"),
    );
  }
}
