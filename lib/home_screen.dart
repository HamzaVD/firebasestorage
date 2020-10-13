import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Storage')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
                color: Colors.blue,
                child: Text("Upload!"),
                onPressed: () async {
                  try {
                    File _file = File(
                        'assets/travel1.jpg'); // rootBundle.load('assets/travel1.jpg') as File;
                    StorageReference ref =
                        FirebaseStorage.instance.ref().child('travel');
                    StorageUploadTask uploadTask = ref.putFile(
                        _file, StorageMetadata(contentType: 'image/png'));
                    StorageTaskSnapshot lastSnapshot =
                        await uploadTask.onComplete;
                    return await lastSnapshot.ref.getDownloadURL();
                  } catch (e) {
                    print(e.toString());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
