import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nine_levelv6/models/user.dart';
import 'package:nine_levelv6/services/services.dart';
import 'package:nine_levelv6/utils/firebase.dart';

class UserService extends Service {
  String currentUid() {
    return firebaseAuth.currentUser.uid;
  }

  Future<UserModel> getUser(String userId) async {
    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    return UserModel.fromJson(userSnapshot.data());
  }

  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

  updateToken(String token) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef.doc(user.uid).update({'Token': token});
    }
  }

  Future<String> getToken(String user) async {
    if (user != null) {
      var datauser = await usersRef.doc(user).get();
      return datauser.get("Token");
    }
    return "";
  }

  updateMoneyUser(String userId, int money) async {
    DocumentSnapshot doc = await usersRef.doc(userId).get();
    var users = UserModel.fromJson(doc.data());
    users?.money += money;

    await usersRef.doc(userId).update({
      'money': users?.money,
    });
  }

  updateProfile(
      {File image, String username, String bio, String country}) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    var users = UserModel.fromJson(doc.data());
    users?.username = username;
    users?.bio = bio;
    users?.country = country;
    if (image != null) {
      users?.photoUrl = await uploadImage(profilePic, image);
    }
    await usersRef.doc(currentUid()).update({
      'username': username,
      'bio': bio,
      'country': country,
      "photoUrl": users?.photoUrl ?? '',
    });

    return true;
  }

  Future<List<String>> getUserFollowingIds(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection("userFollowing").get();

    List<String> following =
        followingSnapshot.docs.map((doc) => doc.id).toList();
    return following;
  }

  Future<List<UserModel>> getUserFollowingUsers(String userId) async {
    List<String> followingUserIds = await getUserFollowingIds(userId);
    List<UserModel> followingUsers = [];

    for (var userId in followingUserIds) {
      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
      UserModel user = UserModel.fromJson(userSnapshot.data());
      followingUsers.add(user);
    }

    return followingUsers;
  }

  Future<List<String>> getUserFollowersIds(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection("usersFollowers").get();

    List<String> followers =
        followersSnapshot.docs.map((doc) => doc.id).toList();
    return followers;
  }

  Future<List<UserModel>> getUserFollowerUsers(String userId) async {
    List<String> followingUserIds = await getUserFollowersIds(userId);
    List<UserModel> followingUsers = [];

    for (var userId in followingUserIds) {
      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
      UserModel user = UserModel.fromJson(userSnapshot.data());
      followingUsers.add(user);
    }

    return followingUsers;
  }
}
