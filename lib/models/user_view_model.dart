import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_model.dart';

class UserViewModel extends GetxController {
  List<UserModel> get userModel => _userModel;
  final List<UserModel> _userModel = [];
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  UserViewModel() {
    getUsers();
  }

  getUsers() async {
    _loading.value = true;
    UserServices().getUser().then((value) {
      for (int i = 0; i < value.length; i++) {
        _userModel
            .add(UserModel.fromJson(value[i].data() as Map<dynamic, dynamic>));
        _loading.value = false;
      }
      update();
    });
  }
}

class UserServices {
  final CollectionReference _usersCollectionRef =
      FirebaseFirestore.instance.collection('Users');

  Future<List<QueryDocumentSnapshot>> getUser() async {
    var value = await _usersCollectionRef.get();
    return value.docs;
  }
}
