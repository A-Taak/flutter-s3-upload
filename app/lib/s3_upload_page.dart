import 'package:app/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/multi_images_utils.dart';

class S3UploadPage extends StatefulWidget {
  const S3UploadPage({super.key});

  @override
  State<S3UploadPage> createState() => _S3UploadPageState();
}

class _S3UploadPageState extends State<S3UploadPage> {
  bool isApiCallprocess = false;
  String singleImageFile = "";
  List<String> selectedMultiImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S3 Uploading"),
      ),
      body: ProgressHUD(
        child: uploadUI(),
        inAsyncCall: isApiCallprocess,
        opacity: .3,
        key: UniqueKey(),
      ),
    );
  }

  uploadUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Single Image",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            child: MultiImagePicker(
              totalImages: 1,
              imageSource: ImagePickSource.gallery,
              initialValue: const [],
              onImageChanged: (images) {
                singleImageFile = images[0].imageFile;
              },
            ),
          ),
          const Text(
            "Multi Images",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            child: MultiImagePicker(
              totalImages: 5,
              imageSource: ImagePickSource.gallery,
              initialValue: const [],
              onImageChanged: (images) {
                selectedMultiImages = [];
                images.forEach(
                  (image) {
                    if (image is ImageUploadModel) {
                      selectedMultiImages.add(image.imageFile);
                    }
                  },
                );

                singleImageFile = images[0].imageFile;
              },
            ),
          ),
          Center(
              child: FormHelper.submitButton(
            "Upload",
            () async {
              setState(() {
                isApiCallprocess = true;
              });

              await APIService.uploadImages(
                      singleImageFile, selectedMultiImages)
                  .then((value) => {
                        setState(() {
                          isApiCallprocess = false;
                        })
                      });
            },
            btnColor: Colors.redAccent,
            borderColor: Colors.redAccent,
            txtColor: Colors.white,
            borderRadius: 10,
          ))
        ],
      ),
    );
  }
}
