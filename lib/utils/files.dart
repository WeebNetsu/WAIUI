import 'package:path/path.dart' as path;

bool isFileSupported(String filePath) {
  // Get the file extension
  String extension = path.extension(filePath).toLowerCase();

  // Check if the file extension matches any of the supported extensions
  List<String> supportedExtensions = ['.mp4', '.mp3', '.wav', '.webm', '.m4a', '.mkv'];
  return supportedExtensions.contains(extension);
}
