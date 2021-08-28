import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  Future uploadFileAndGetDownloadUrl(
      {@required File file, @required String uid}) async {
    var name =
        uid + DateTime.now().millisecondsSinceEpoch.toString(); //uniqueID

    Reference ref = storage.ref().child(name);

    TaskSnapshot task = await ref.putFile(file); //uploading

    var downloadUrl = await task.ref.getDownloadURL();
    return downloadUrl;
  }

  Future uploadImageAndGetDownloadUrl(
      {@required File image, @required String uid}) async {
    var imageFileName = uid; //uniqueID

    Reference ref = storage.ref().child(imageFileName);

    TaskSnapshot task =
        await ref.putFile(image).catchError((e) => e); //uploading

    var downloadUrl = await task.ref.getDownloadURL().catchError((e) => e);
    return [downloadUrl];
  }
}
