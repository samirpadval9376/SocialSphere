import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PostController extends ChangeNotifier {
  String imageUrl = "";
  String? username;
  String? fullName;
  String? dob;
  String? newPassword;
  String? password;
  String image = "";

  String img = "";

  File? imagePath;

  List<String> items = [];

  updateUsername({required String val}) {
    username = val;
    notifyListeners();
  }

  oldPassword({required String val}) {
    password = val;
    notifyListeners();
  }

  updateFullName({required String val}) {
    fullName = val;
    notifyListeners();
  }

  updateDob({required String val}) {
    dob = val;
    notifyListeners();
  }

  updatePassword({required String val}) {
    newPassword = val;
    notifyListeners();
  }

  Future<void> storeImage() async {
    String fileName = basename(imageUrl);

    String location = 'posts/$fileName.jpg';

    Reference reference = FirebaseStorage.instance.ref().child(location);

    await reference.putFile(File(imageUrl));

    imageUrl = await reference.getDownloadURL();

    log("Image: $imageUrl");
  }

  Future<void> storeUserImage() async {
    img = imagePath!.path;

    String fileName = basename(img);

    String location = 'user_image/$fileName';

    Reference reference = FirebaseStorage.instance.ref().child(location);

    await reference.putFile(File(img));

    img = await reference.getDownloadURL();

    log("Image: $img");

    notifyListeners();
  }

  updateUserImage() async {
    await updateImage();

    String fileName = basename(image);

    String location = 'user_image/$fileName';

    Reference reference = FirebaseStorage.instance.ref().child(location);

    await reference.putFile(File(image));

    image = await reference.getDownloadURL();

    log("Image: $image");

    notifyListeners();
  }

  Future<void> updateImage() async {
    XFile? images = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (images != null) {
      image = images.path;
    }
    notifyListeners();
  }

  Future<void> changeImage() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (img != null) {
      imageUrl = img.path;
    }
    await storeImage();
    notifyListeners();
  }

  void addImage({required File img}) {
    imagePath = img;
    notifyListeners();
  }

  search({required String username, required List<String> allFollowers}) {
    items = allFollowers
        .where((element) =>
            element.toString().toLowerCase().contains(username.toLowerCase()))
        .toList();
  }
}
