import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _imageFile;
  final picker = ImagePicker();

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        iosUiSettings: IOSUiSettings(
          title: 'Cropping image',
        ));

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }
  void _clear() {
    setState(() => _imageFile = null);
  }

  Future _uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('images').child('/$fileName');
    await ref.putFile(_imageFile).whenComplete(() async {
      await ref.getDownloadURL().then((value) async {
        FirebaseFirestore.instance.collection('imageURLs').add({'url': value});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop Image'), actions: [
        TextButton(
          onPressed: _pickImage,
          child: Icon(Icons.photo_library, color: Colors.white),
        ),
      ]),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Container(
                padding: EdgeInsets.all(40), child: Image.file(_imageFile)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                ElevatedButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
                ElevatedButton(
                  child: Icon(Icons.upload),
                  onPressed: _uploadImageToFirebase,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
