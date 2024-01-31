import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monument_recognition/providers/cameraProvider.dart';

import 'package:monument_recognition/screens/tabs.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (fn) {
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camera = ref.read(cameraProvider);
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
      home: FutureBuilder(
        future: camera,
        builder: ((context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : TabsScreen(selectedCamera: snapshot.data!)),
      ),
    );
  }
}
