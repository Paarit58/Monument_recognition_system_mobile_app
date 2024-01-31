import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monument_recognition/models/imagePicker.dart';
import 'package:monument_recognition/screens/DisplayScreen.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({
    super.key,
  });
  late File _image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          _image = await Image_Picker().getImageFromGallery();
          //image file is returned here
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DisplayScreen(
                      selectedImage: _image,
                    ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                }),
          );
        },
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.photo_album),
          Text('Select Your Monument'),
        ]),
      ),
    );
  }
}
