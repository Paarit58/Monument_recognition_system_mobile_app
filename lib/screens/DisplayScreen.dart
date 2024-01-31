// A widget that displays the picture taken by the user.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monument_recognition/Classifier/Inference.dart';

import 'package:monument_recognition/providers/monuments_data_provider.dart';

class DisplayScreen extends ConsumerStatefulWidget {
  const DisplayScreen({
    super.key,
    required this.selectedImage,
  });
  final File selectedImage;

  @override
  ConsumerState<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends ConsumerState<DisplayScreen> {
  //getting the prediction for selected or captured image
  late Future<List> predict =
      Inference(selectedImage: widget.selectedImage).output;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final monuments = ref.read(monumentsProvider);
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
                  future: predict,
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final data = snapshot.data as List<double>;
                      double maxNumber = data.reduce((value, element) => value >
                              element
                          ? value
                          : element); //Finding maximum value in the result's list

                      final index = data.indexOf(maxNumber);
                      final monumentName = monuments.asMap()[index]?.name;
                      final monumentDescription =
                          monuments.asMap()[index]?.description;

                      return Expanded(
                        child: ListView(
                          children: [
                            Text('$monumentName',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                textAlign: TextAlign.center),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Description :',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('$monumentDescription'),
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
