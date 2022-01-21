import 'package:ajanda_flutter/model/Diary.dart';
import 'package:ajanda_flutter/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:universal_html/html.dart';
import 'package:ajanda_flutter/widgets/inner_list_card.dart';
import 'package:ajanda_flutter/widgets/delete_entry_dialog.dart';

// görevlerin düzenleme ekranı

class UpdateEntryDialog extends StatefulWidget {
  const UpdateEntryDialog({
    Key? key,
    required this.diary,
    required CollectionReference linkReference,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
    required this.widget,
  })  : _titleTextController = titleTextController,
        _linkReference = linkReference,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final Diary diary;
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final CollectionReference _linkReference;
  final InnerListCard widget;

  @override
  _UpdateEntryDialogState createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //discard
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextButton(
                    child: Text('Discard'),
                    style: TextButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // done
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextButton(
                    child: Text('Done'),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(
                                color: Colors.deepPurple, width: 1))),
                    onPressed: () {
                      var _user = FirebaseAuth.instance.currentUser;
                      final _fieldNotEmpty =
                          widget._titleTextController.text.isNotEmpty &&
                              widget._descriptionTextController.text.isNotEmpty;
                      final diaryTitleChanged = widget.diary.title !=
                          widget._titleTextController.text;
                      final diaryEntryChanged = widget.diary.entry !=
                          widget._descriptionTextController.text;
                      final diaryUpdate =
                          diaryTitleChanged || diaryEntryChanged != null;
                      //final dateTime = DateTime.now();
                      // final path = '$dateTime';
                      if (_fieldNotEmpty && diaryUpdate) {
                        widget._linkReference.doc(widget.diary.id).update(Diary(
                                userId: _user!.uid,
                                author: _user.email!.split('@')[0],
                                title: widget._titleTextController.text,
                                entry: widget._descriptionTextController.text,
                                entryTime: Timestamp.fromDate(
                                    //widget.widget.selectedDate!,
                                    DateTime.now()))
                            .toMap());
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    //silme butonu
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteEntryDialog(
                                        bookCollectionReference:
                                            widget._linkReference,
                                        diary: widget.diary);
                                  },
                                );
                              },
                              splashRadius: 26,
                              color: Colors.red,
                              icon: Icon(Icons.delete_forever_rounded)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  // tarih
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${formatDateFromTimestamp(this.widget.diary.entryTime)}'),
                        SizedBox(height: 50),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Form(
                              child: Column(children: [
                                TextFormField(
                                  validator: (value) {},
                                  controller: widget._titleTextController,
                                  decoration:
                                      InputDecoration(hintText: 'Title'),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  maxLines: null,
                                  validator: (value) {},
                                  keyboardType: TextInputType.multiline,
                                  controller: widget._descriptionTextController,
                                  decoration: InputDecoration(
                                      hintText: 'Write your thoughts here'),
                                )
                              ]),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
