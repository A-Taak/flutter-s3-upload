// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<bool> uploadImages(
      String singleImageFile, List<String> multipleImages) async {
    var url = Uri.http("127.0.0.1:3000", "/api/image-upload");

    var request = http.MultipartRequest("POST", url);

    if (singleImageFile.isNotEmpty) {
      http.MultipartFile singleFile =
          await http.MultipartFile.fromPath("singlefile", singleImageFile);

      request.files.add(singleFile);
    }

    if (multipleImages.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      multipleImages.forEach((file) async {
        http.MultipartFile multiFile =
            await http.MultipartFile.fromPath("multiplefiles", file);
        request.files.add(multiFile);
      });
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
