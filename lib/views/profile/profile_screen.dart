import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery/views/Authentication/Authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No Images selected');
      }
    });
  }

  Future uploadImageToChangeAvatar() async {
    String fileName = basename(_image.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('avatarImage').child('/$fileName');
    await ref.putFile(_image).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('avatarImageURLs')
            .add({'url': value});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Column(children: [
        SizedBox(height: 30),
        CircleAvatar(
          radius: 60,
          backgroundImage: _image == null ? null : FileImage(_image),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: getImageFromGallery,
              child: Text('Change Avatar'),
            ),
            ElevatedButton(
              onPressed: uploadImageToChangeAvatar,
              child: Text('Submit Avatar'),
            ),
          ],
        ),
        SizedBox(height: 30),
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.person),
          title: Text("Alex"),
        ),
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.mail),
          title: Text("ml19xl3@leeds.ac.uk"),
        ),
        SizedBox(height: 30),
      ]))),
    );
  }
}
