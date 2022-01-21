import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

//kullanıcı bilgileri

class MUser {
  final String? id;
  final String? uid;
  final String? displayName;
  final String? profession;
  final String? avatarUrl;

  MUser({this.id, this.uid, this.displayName, this.profession, this.avatarUrl});

  factory MUser.fromDocument(DocumentSnapshot docs) {
    Map<String, dynamic> data = docs.data()! as Map<String, dynamic>;
    return MUser(
      id: data['id'],
      uid: data['uid'],
      displayName: data['display_name'],
      profession: data['profession'],
      avatarUrl: data['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'profession': profession,
      'avatar_url': avatarUrl
    };
  }
}