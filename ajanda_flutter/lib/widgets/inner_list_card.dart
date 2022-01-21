import 'package:ajanda_flutter/model/Diary.dart';
import 'package:ajanda_flutter/util/utils.dart';
import 'package:ajanda_flutter/widgets/delete_entry_dialog.dart';
import 'package:ajanda_flutter/widgets/update_entry_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ekranda görünen görev kartlarının işlevi silme butonu-basınca full görünümün açılması

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key? key,
    required this.diary,
    required this.selectedDate,
    required this.bookCollectionReference,
  }) : super(key: key);

  final Diary diary;
  final DateTime? selectedDate;
  final CollectionReference<Object?> bookCollectionReference;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleTextController =
        TextEditingController(text: diary.title);
    final TextEditingController _descriptionTextController =
        TextEditingController(text: diary.entry);

    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ana ekranda görünen kartların üzerindeki silme butonu
              children: [
                Text(
                  '${formatDateFromTimestamp(diary.entryTime)}',
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                // silme butonu
                TextButton.icon(
                    icon: Icon(Icons.delete_forever, color: Colors.grey),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteEntryDialog(
                              bookCollectionReference: bookCollectionReference,
                              diary: diary);
                        },
                      );
                    },
                    label: Text(''))
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('•${formatDateFromTimestampHour(diary.entryTime)}',
                      style: TextStyle(color: Colors.deepPurple)),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz),
                      label: Text('')),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(diary.title!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              diary.entry!,
                            ),
                          ),
                        ]),
                  ),
                ],
              )
            ],
          ),
          // her bir kartın üstüne basında açılan düzenleme sayfası
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          children: [
                            Spacer(),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateEntryDialog(
                                        diary: diary,
                                        titleTextController:
                                            _titleTextController,
                                        descriptionTextController:
                                            _descriptionTextController,
                                        //selectedDate: selectedDate!,
                                        widget: this,
                                        linkReference: bookCollectionReference,
                                      );
                                    },
                                  );
                                }),
                            SizedBox(width: 25),
                            IconButton(
                                icon: Icon(Icons.delete_forever_rounded),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteEntryDialog(
                                          bookCollectionReference:
                                              bookCollectionReference,
                                          diary: diary);
                                    },
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                  content: ListTile(
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formatDateFromTimestamp(diary.entryTime)}',
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formatDateFromTimestampHour(diary.entryTime)}',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${diary.title}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${diary.entry}',
                                    style: TextStyle(),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
