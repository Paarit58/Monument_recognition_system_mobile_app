import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:monument_recognition/screens/tabs.dart';
import 'package:camera/camera.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();

  final cameras = await availableCameras();
// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (fn) {
      runApp(
        MyApp(camera: firstCamera),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  // This widget is the root of your application.
  @override
  Widget build(
    BuildContext context,
  ) {
    // final camera = ref.read(cameraProvider);
    return MaterialApp(
      title: 'Monument Detection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 228, 156, 40),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.kuraleTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 220, 175, 69),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: TabsScreen(selectedCamera: camera),
      //  FutureBuilder(
      //   future: camera,
      //   builder: ((context, snapshot) =>
      //       snapshot.connectionState == ConnectionState.waiting
      //           ? const CircularProgressIndicator()
      //           : TabsScreen(selectedCamera: snapshot.data!)),
      // ),
    );
  }
}
