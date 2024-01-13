// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garb/dbhelper.dart';
import 'package:garb/photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  database  اللي عاوزين نحطه في   model  ال
  Photo photo = Photo();

  //  الفايل اللي هنسيف فيه الصوره
  File file = File('');
  // database الليست اللي هنجبها من ال
  List<Photo> _photos = [];
  List<Photo> get photos => _photos;
  // اللي هنسيف فيه ال الصوره path  ال
  String appDocumentsPath = '';
  //  local database  اسم الصوره ودي بس اللي هتتسجل في ال
  String imageName = '';

  @override
  void initState() {
    // هنجيب كل الصور
    getAllProduct();
    super.initState();
  }

  //  gallary or camera ... هنجيب الصوره منين سواء ال
  final ImagePicker _picker = ImagePicker();

  var dbHelper = DBHelper.db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _onImageButtonPressed();
          });
        },
        heroTag: 'image0',
        tooltip: 'Pick Image from gallery',
        child: const Icon(Icons.photo),
      ),
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView.builder(
        itemCount: _photos.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.file(
            //  local database لما نجيب الصوره اللي حطناها في ال
            // 1-appDocumentsPath   :  getAllProduct ده هنجيبه في ال ميثود دي
            //2- photoName  :  اللي متسجله في الداتا بيز
            File('$appDocumentsPath/${_photos[index].photoName}'),
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  _onImageButtonPressed() async {
    try {
      // هنجيب الصوره عن طريق اي
      final myfile = await _picker.pickImage(source: ImageSource.gallery);
      //  myfile   الفايل اللي هتتحفظ فيه الصوره
      file = File(myfile!.path);
      // file    الخالص بالصوره  path
      print('file ' + '${file}');
      imageName = file.path.split('/').last;
      // imageName : اخر جزء من الفايل اسم الصوره
      print('imageName ' + '${imageName}');
      // اللي هتتحط فيه الصوره Directory  ال
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory(); // 1
      appDocumentsPath = appDocumentsDirectory.path; // 2

      // appDocumentsPath :    /data/user/0/com.example.garb/app_flutter        في الأغلب هتلاقيه كده
      // ده اسم الابليكشن الخاص بيك  garb خلي بالك
      print('appDocumentsPath  ' + '${appDocumentsPath}');

      // appDocumentsPath   ل  هنغير الفايل من
      //print('name ' + '${file}');   و ال print('file ' + '${file}')   هتلاحظ الفرق في ال

      file = File('$appDocumentsPath/$imageName');
      // هحفظ اسم الصوره في الداتا بيز
      photo.photoName = imageName;
      dbHelper.save(photo);

      print('name photoName ' + photo.photoName);
      print('name ' + '${file}');
      print('path2' + '${appDocumentsPath}');
    } catch (e) {}
  }

  getAllProduct() async {
    // هنجيب الصور من الداتا بيز
    _photos = await dbHelper.getAllPhotos();

    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    appDocumentsPath = appDocumentsDirectory.path; // 2

    // هنشوف اسم كل سوره في الداتا بيز
    _photos.forEach((name) {
      imageName = name.photoName;
      print('3m ' + '${imageName}');
    });

    print('appDocumentsPath ' + '${appDocumentsPath}');
    print('lenght ' + '${_photos.length}');

    setState(() {});
  }
}
