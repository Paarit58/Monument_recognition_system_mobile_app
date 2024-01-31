import 'dart:isolate';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class Inference {
  Inference({
    required this.selectedImage,
  });
  final File selectedImage;

  /// Loads interpreter from asset
  Future<Interpreter> loadModel() async {
    try {
      final interpreter = await Interpreter.fromAsset(
        'assets/1.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      // Tensor inputTensor = interpreter.getInputTensors().first;

      interpreter.resizeInputTensor(0, [1, 128, 128, 3]);

      interpreter.allocateTensors();
      // print(interpreter.getInputTensor(0).shape);
      return interpreter;
    } catch (e) {
      print("Error while creating interpreter: $e");
      throw ();
    }
  }

  Future<List<List<List<int>>>> readImage(File image) async {
    List<List<List<int>>> imgarr = [];
    final bytes = await image.readAsBytes();
    final decoder = img.JpegDecoder();
    final decodedImg = decoder.decode(bytes);
    final resizedImage = img.copyResize(decodedImg!, height: 128, width: 128);
    final decodedBytes = resizedImage.getBytes(order: img.ChannelOrder.rgb);

    //Getting matrix of image with RGB values
    for (int y = 0; y < resizedImage.height; y++) {
      imgarr.add([]);
      for (int x = 0; x < resizedImage.width; x++) {
        int red = decodedBytes[y * resizedImage.width * 3 + x * 3];
        int green = decodedBytes[y * resizedImage.width * 3 + x * 3 + 1];
        int blue = decodedBytes[y * resizedImage.width * 3 + x * 3 + 2];
        imgarr[y].add([red, green, blue]);
      }
    }

    return imgarr;
  }

  /// Gets the interpreter instance
  // Interpreter get interpreter => interpreter;

  Future<List<num>> runInference(
      List<List<List<num>>> imageMatrix, Interpreter interpreter) async {
    try {
      // Preprocess the image if necessary (e.g., resize, normalize, etc.)

      // Perform inference
      // final output = List.filled(interpreter.getOutputTensors().length, 0);
      final input = [imageMatrix];
      final output = [List<num>.filled(9, 0)];

      interpreter.run(input, output);

      final result = output.first;
      return result;
    } catch (e) {
      print('Error running inference: $e');
      return [] as List<num>;
    }
  }

  Future<List<num>> get output async {
    final image = await Isolate.run(() => readImage(selectedImage));

    final interpreter = await loadModel();
    final output = await runInference(image, interpreter);
    return output;
  }
}
