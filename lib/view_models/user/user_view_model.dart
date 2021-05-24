import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  User user;
  FirebaseAuth auth = FirebaseAuth.instance;

  UserService userService = UserService();

  setUser() {
    user = auth.currentUser;
    //notifyListeners();
  }

  Future<UserModel> getUser(String uid) async {
    return userService.getUser(uid);
  }

  updateToken(String token) {
    userService.updateToken(token);
  }

  Future<String> getToken(String user) async {
    return await userService.getToken(user);
  }

  Future<List<UserModel>> getUserFollowingUsers(String userId) async {
    return await userService.getUserFollowingUsers(userId);
  }

  Future<List<UserModel>> getUserFollowerUsers(String userId) async {
    return await userService.getUserFollowerUsers(userId);
  }
}
