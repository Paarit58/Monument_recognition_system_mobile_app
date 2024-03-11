// A widget that displays the picture taken by the user.
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({
    super.key,
    required this.selectedImage,
  });
  final File selectedImage;

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  //getting the prediction for selected or captured image

  Future predictData() async {
    const String baseUrl = 'http://192.168.101.11:8000/predict';
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(widget.selectedImage.path,
          filename: 'image.jpg'),
    });
    final response = await Isolate.run(() => dio.post(baseUrl,
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        })));

    return response.data;
  }

  @override
  void dispose() {
    super.dispose();
    // ImageCache().evict(FileImage(widget.selectedImage));
    // ImageCache().clear();

    FileImage(widget.selectedImage).evict();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 20,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(widget.selectedImage),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10)),
                height: 300,
                width: double.infinity,
              ),
              FutureBuilder(
                  future: predictData(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final data = snapshot.data;
                      final monumentsName = data['class'];
                      double confidence = data['confidence'];
                      final rconfidence = confidence.toStringAsFixed(2);
                      final monumentDescription = data['description'];

                      return Expanded(
                        child: ListView(
                          children: [
                            Text('$monumentsName',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                textAlign: TextAlign.center),
                            Text(
                              'Confidence($rconfidence)',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Description :',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(
                              height: 20,
                            ),
                            Text("$monumentDescription"),
                          ],
                        ),
                      );
                    }
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
