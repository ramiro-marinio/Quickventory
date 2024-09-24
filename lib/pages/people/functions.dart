import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

String detectImageFormat(Uint8List imageBytes) {
  // Check if it is PNG (starts with 89 50 4E 47)
  if (imageBytes.length > 4 &&
      imageBytes[0] == 0x89 &&
      imageBytes[1] == 0x50 &&
      imageBytes[2] == 0x4E &&
      imageBytes[3] == 0x47) {
    return 'png';
  }

  // Check if it is JPEG (starts with FF D8 FF)
  if (imageBytes.length > 3 &&
      imageBytes[0] == 0xFF &&
      imageBytes[1] == 0xD8 &&
      imageBytes[2] == 0xFF) {
    return 'jpeg';
  }

  // Check if it is GIF (starts with 47 49 46 38)
  if (imageBytes.length > 4 &&
      imageBytes[0] == 0x47 &&
      imageBytes[1] == 0x49 &&
      imageBytes[2] == 0x46 &&
      imageBytes[3] == 0x38) {
    return 'gif';
  }

  throw Exception('Unknown Format.'); // Default if format is not recognized
}

Future<String> saveImage(Uint8List bytes, String userId) async {
  try {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create the full file path
    await createUserDirectory(userId);
    final filePath = path.join(
      '${directory.path}/users/$userId',
      'photo.${detectImageFormat(bytes)}',
    );

    // Create the file and write the bytes
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath; // Return the file path where the image is saved
  } catch (e) {
    print("Error saving image: $e");
    throw Exception(e);
  }
}

String getRandomString(int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join('');
}

Future<void> createUserDirectory(String userId) async {
  final directory = await getApplicationDocumentsDirectory();
  final userDir = Directory('${directory.path}/users/$userId');

  if (!(await userDir.exists())) {
    await userDir.create(recursive: true);
    print("User directory created at: ${userDir.path}");
  }
}
