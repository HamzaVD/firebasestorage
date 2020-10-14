import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Storage')),
      body: ListView(
        children: [
          imageUrl != null
              ? Image.network(imageUrl)
              : Placeholder(
                  fallbackHeight: 200.0, fallbackWidth: double.infinity),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () => _uploadImage(),
            color: Colors.lightBlue,
            child: Text('Upload image'),
          )
        ],
      ),
    );
  }

  _uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    // Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      // select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        // upload to Firebase
        var now = new DateTime.now();
        var snapshot =
            await _storage.ref().child('profile/$now').putFile(file).onComplete;
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No path received');
      }
    } else {
      print('Grant Permissions and try again!');
    }
  }
}
