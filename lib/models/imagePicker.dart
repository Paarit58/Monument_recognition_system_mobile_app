import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Image_Picker {
  late File _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    return _image;
  }
}
