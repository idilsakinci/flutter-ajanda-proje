import 'package:ajanda_flutter/model/Diary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// görev silme butonuna basınca gelen ekran

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.bookCollectionReference,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Object?> bookCollectionReference;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Entry?',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
          'Are you sure you want to delete the entry? \n This action cannot be reversed.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            bookCollectionReference.doc(diary.id).delete().then((value) {
              return Navigator.of(context).pop();
            });
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
