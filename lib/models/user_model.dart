class UserModel {
  late String userId, email, name, pic;
  dynamic userLat;
  dynamic userLng;
  UserModel(
      {required this.userId,
      required this.email,
      required this.name,
      required this.userLat,
      required this.userLng,
      required this.pic});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map.isEmpty) {
      return;
    }

    userId = map['userId'];
    email = map['email'];
    userLat = map['userLat'];
    userLng = map['userLng'];
    name = map['name'];
    pic = map['pic'].toString();
  }
  toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'userLat': userLat,
      'userLng': userLng,
      'pic': pic,
    };
  }
}
