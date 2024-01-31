import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<CameraDescription> getCamera() async {
  final cameras = await availableCameras();
// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  return firstCamera;
}

final camera = getCamera();
final cameraProvider = Provider((ref) {
  return camera;
});
