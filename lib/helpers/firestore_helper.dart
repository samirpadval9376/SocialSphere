import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/modals/user_modal.dart';

import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String collectionPath = "Users";

  Future<void> addUser({required UserModal userModal}) async {
    await fireStore
        .collection(collectionPath)
        .doc(userModal.email)
        .set(userModal.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    String? email = Auth.auth.firebaseAuth.currentUser!.email;

    return fireStore
        .collection(collectionPath)
        .where('email', isNotEqualTo: email)
        .snapshots();
  }
}
