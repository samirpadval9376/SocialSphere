import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/modals/chat_modal.dart';
import 'package:social_media_app/modals/follower_modal.dart';
import 'package:social_media_app/modals/likes_modal.dart';
import 'package:social_media_app/modals/message_modal.dart';
import 'package:social_media_app/modals/post_modal.dart';
import 'package:social_media_app/modals/user_modal.dart';

import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String collectionPath = "Users";
  String collection = "Followers";
  String following = "Following";
  String posts = "Posts";
  String chats = "Chats";
  String likes = "Likes";
  String messages = "Messages";
  String saved = "Saved";
  String story = "Story";

  Future<void> addUser({required UserModal userModal}) async {
    await fireStore
        .collection(collectionPath)
        .doc(userModal.email)
        .set(userModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData(
      {required String username}) {
    return fireStore
        .collection(collectionPath)
        .where('username', isEqualTo: username)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore.collection(collectionPath).doc(email).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> likesData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore
        .collection(collectionPath)
        .where('email', isEqualTo: email)
        .snapshots();
  }

  Future<void> addFollower(
      {required UserModal userModal, required String id}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    FollowModal followModal = FollowModal(
      username: userModal.username,
      email: userModal.email,
      image: userModal.image,
      createdTime: userModal.createdTime,
    );

    await fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(following)
        .doc(id)
        .set(followModal.toMap);
  }

  Future<void> addFollowing({required UserModal userModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    FollowModal followModal = FollowModal(
      username: userModal.username,
      email: userModal.email,
      image: userModal.image,
      createdTime: userModal.createdTime,
    );

    await fireStore
        .collection(collectionPath)
        .doc(followModal.email)
        .collection(collection)
        .doc(email)
        .set(followModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> followingData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(following)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowingData(
      {required String username}) {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(following)
        .where('username', isEqualTo: username)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowerData(
      {required String username}) {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(collection)
        .where('username', isEqualTo: username)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> followersData(
      {required String id}) {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(collection)
        .snapshots();
  }

  Future<void> unfollow({required String followEmail}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    await fireStore
        .collection(collectionPath)
        .doc(email)
        .collection(following)
        .doc(followEmail)
        .delete();

    await fireStore
        .collection(collectionPath)
        .doc(followEmail)
        .collection(collection)
        .doc(email)
        .delete();
  }

  Future<void> addPost({required PostModal postModal}) async {
    await fireStore
        .collection(posts)
        .doc(postModal.time.millisecondsSinceEpoch.toString())
        .set(postModal.toMap);
  }

  Future<void> getPosts({required PostModal postModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();

    List posts = allData?['posts'] ?? {};

    posts.add({
      'description': postModal.description,
      'image': postModal.imageUrl,
      'email': postModal.email,
      'time': postModal.time.millisecondsSinceEpoch,
    });
    await fireStore
        .collection(collectionPath)
        .doc(email)
        .update({'posts': posts});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> showPosts() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore
        .collection(posts)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatList() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    return fireStore
        .collection(chats)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }

  Future<void> addChat(
      {required ChatModal chatModal, required Map user}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    log("---------------------------------------------------------");
    log(chatModal.email);

    log("---------------------------------------------------------");
    await fireStore.collection(chats).doc(email).set(chatModal.toMap);
    await fireStore.collection(chats).doc(chatModal.email).set({
      'username': user['username'],
      'email': user['email'],
      'fullName': user['fullName'],
      'image': user['image'],
      'lastMessage': "",
    });
  }

  Future<void> sentMessage(
      {required MessageModal messageModal,
      required String senderId,
      required String receiverId}) async {
    Map<String, dynamic> data = messageModal.toMap;

    data.update('type', (value) => 'sent');

    await fireStore
        .collection(chats)
        .doc(senderId)
        .collection(receiverId)
        .doc(messageModal.dateTime.millisecondsSinceEpoch.toString())
        .set(data);

    data.update('type', (value) => 'rec');

    await fireStore
        .collection(chats)
        .doc(receiverId)
        .collection(senderId)
        .doc(messageModal.dateTime.millisecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required String senderId, required String receiverId}) {
    return fireStore
        .collection(chats)
        .doc(senderId)
        .collection(receiverId)
        .snapshots();
  }

  Future<void> lastMessage(
      {required String id,
      required String email,
      required String msg,
      required ChatModal chatModal}) async {
    Map<String, dynamic> data = chatModal.toMap;

    data.update('lastMessage', (value) => msg);

    await fireStore.collection(chats).doc(id).update(data);
    await fireStore.collection(chats).doc(email).update({'lastMessage': msg});
  }

  Future<void> updateFollowing(
      {required String username,
      required String image,
      required String id}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();

    List followingUsers = allData?['followingUsers'] ?? {};

    followingUsers.add({
      'username': username,
      'image': image,
      'email': id,
    });

    await fireStore.collection(collectionPath).doc(email).update({
      'followingUsers': followingUsers,
    });
  }

  Future<void> updateFollowers(
      {required String username,
      required String image,
      required String docEmail,
      required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();

    List followerUsers = allData?['followerUsers'] ?? {};

    followerUsers.add({
      'username': username,
      'image': image,
      'email': email,
    });

    await fireStore
        .collection(collectionPath)
        .doc(docEmail)
        .update({'followerUsers': followerUsers});
  }

  Future<void> updateLikes(
      {required UserModal userModal, required String time}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(posts).doc(time).get();

    Map<String, dynamic>? allData = data.data();

    List likes = allData?['likes'] ?? [];

    likes.add({
      'username': userModal.username,
      'image': userModal.image,
      'email': userModal.email,
    });
    await fireStore.collection(posts).doc(time).update({'likes': likes});
  }

  Future<void> allLikes({required LikesModal likesModal}) async {
    await fireStore
        .collection(likes)
        .doc(likesModal.time.millisecondsSinceEpoch.toString())
        .set(likesModal.toMap);
  }

  updateDislikes({required UserModal userModal, required String time}) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(posts).doc(time).get();

    Map<String, dynamic>? allData = data.data();
    List likes = allData?['likes'] ?? {};
    likes.removeWhere((element) => element['email'] == userModal.email);

    log(likes.toString());

    await fireStore.collection(posts).doc(time).update({'likes': likes});
  }

  removeFollowing({required String id}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();
    List followingUsers = allData?['followingUsers'] ?? {};
    followingUsers.removeWhere((element) => element['email'] == id);

    log(followingUsers.toString());

    await fireStore
        .collection(collectionPath)
        .doc(email)
        .update({'followingUsers': followingUsers});
  }

  removeFollower({required String id}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();
    //
    List followerUsers = allData?['followerUsers'] ?? {};
    //
    followerUsers.removeWhere((element) => element['email'] == id);

    log(followerUsers.toString());

    await fireStore
        .collection(collectionPath)
        .doc(id)
        .update({'followerUsers': followerUsers});
  }

  Future<void> updateProfile(
      {required String username,
      required String password,
      required String fullName,
      required String image,
      required String dob,
      required UserModal userModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    Map<String, dynamic> data = userModal.toMap;

    data.update('username', (value) => username);
    data.update('password', (value) => password);
    data.update('fullName', (value) => fullName);
    data.update('image', (value) => image);
    data.update('dob', (value) => dob);

    await fireStore.collection(collectionPath).doc(email).update(data);
  }

  Future<void> mySaved({required PostModal postModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    await fireStore.collection(saved).doc(email).set(postModal.toMap);
  }

  unSaved() async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    await fireStore.collection(saved).doc(email).delete();
  }

  Future<void> updateSaved({required PostModal postModal}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();

    List saved = allData?['saved'] ?? [];

    saved.add({
      'username': postModal.username,
      'image': postModal.imageUrl,
      'email': postModal.email,
      'userImage': postModal.userImage,
      'description': postModal.description,
    });
    await fireStore
        .collection(collectionPath)
        .doc(email)
        .update({'saved': saved});
  }

  Future<void> removeSaved({required String id}) async {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;
    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection(collectionPath).doc(email).get();

    Map<String, dynamic>? allData = data.data();
    //
    List saved = allData?['saved'] ?? {};
    //
    saved.removeWhere((element) => element['image'] == id);

    log(saved.toString());

    await fireStore
        .collection(collectionPath)
        .doc(email)
        .update({'saved': saved});
  }
  // addStory() {
  //   fireStore.collection(story).doc()
  // }
}
