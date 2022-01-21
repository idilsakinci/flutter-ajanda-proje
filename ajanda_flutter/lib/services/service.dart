import 'package:ajanda_flutter/model/Diary.dart';
import 'package:ajanda_flutter/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';

import '../model/Diary.dart';
import '../model/user.dart';


class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('ajandalar');

  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return;
  }

  Future<void> createUser(
      String displayName, BuildContext context, String uid) async {
    var u = {
      'avatar_url': 'https://picsum.photos/200/300',
      'uid': uid,
      'display_name': displayName,
    };

    MUser user = MUser(
        avatarUrl: 'https://picsum.photos/200/300',
        displayName: displayName,
        uid: uid);
    userCollectionReference.add(user.toMap());
    return;
  }

  Future<void> update(MUser user, String displayName, String avatarUrl,
      BuildContext context) async {
    MUser updateUser =
        MUser(displayName: displayName, avatarUrl: avatarUrl, uid: user.uid);

    userCollectionReference
        .doc(user.id)
        .update(updateUser.toMap())
        .onError((error, stackTrace) => print(error.toString()));
    return;
  }

  Future<List<Diary>> getSameDateDiaries(DateTime first, String userId) {
    return diaryCollectionReference
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(first.add(Duration(days: 1))).toDate())
        .where('user_id', isEqualTo: userId)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      }).toList();
    });
  }

  getLatestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: true)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }

  getEarliestDiaries(String uid) {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) {
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      });
    });
  }
}
