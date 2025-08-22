class TransferProtocol {
  static const chunkSize = 1024 * 8;
  static const int port = 5000;

  static Map<String, dynamic> createHeader(String fileName, int fileSize) {
    return {
      "fileName": fileName,
      "fileSize": fileSize,
    };
  }
}
