import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:monument_recognition/screens/TakePictureScreen.dart';
import 'package:monument_recognition/screens/galleryScreen.dart';

// ignore: must_be_immutable
class TabsScreen extends ConsumerStatefulWidget {
  TabsScreen({super.key, required this.selectedCamera});
  CameraDescription selectedCamera;

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = TakePictureScreen(
      camera: widget.selectedCamera,
    );
    var activePageTitle = 'Take the picture of your Monument';

    if (_selectedPageIndex == 1) {
      activePage = GalleryScreen();
      activePageTitle = 'Choose from gallery!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Capture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Select from gallery',
          ),
        ],
      ),
    );
  }
}
