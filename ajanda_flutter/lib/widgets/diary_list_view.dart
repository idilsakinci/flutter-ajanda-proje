import 'package:ajanda_flutter/model/Diary.dart';
import 'package:ajanda_flutter/pages/main_page.dart';
import 'package:ajanda_flutter/util/utils.dart';
import 'package:ajanda_flutter/widgets/delete_entry_dialog.dart';
import 'package:ajanda_flutter/widgets/inner_list_card.dart';
import 'package:ajanda_flutter/widgets/write_diary_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// görevlerin liste şeklinde sıralanması güne göre

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required List<Diary> listOfDiaries,
    required this.selectedDate,
  })  : _listOfDiaries = listOfDiaries,
        super(key: key);
  final DateTime selectedDate;
  final List<Diary> _listOfDiaries;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('ajandalar');
    final _user = Provider.of<User?>(context);

    var _diaryList = this._listOfDiaries;
    var filteredDiaryList = _diaryList.where((element) {
      return (element.userId == _user!.uid);
    }).toList();

    return Column(
      children: [
        Expanded(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: (filteredDiaryList
                  .isNotEmpty) // eğer gün içinde görev varsa-boş değilse- gösterilecek ekran
              ? ListView.builder(
                  itemCount: filteredDiaryList.length,
                  itemBuilder: (context, index) {
                    Diary diary = filteredDiaryList[index];
                    // her bir görev kartının yapısı
                    //effectli geliş cardların
                    return DelayedDisplay(
                      delay: Duration(milliseconds: 1),
                      fadeIn: true,
                      child: Card(
                        elevation: 4.0,
                        child: InnerListCard(
                            selectedDate: this.selectedDate,
                            diary: diary,
                            bookCollectionReference: bookCollectionReference),
                      ),
                    );
                  },
                )
              // eğer gün içinde herhangi bir görev yoksa gelecek ekran görünümü
              : ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    // her bir görev kartının yapısı
                    return Card(
                      elevation: 4.0,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'You do not have entry on ${formatDate(selectedDate)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  TextButton.icon(
                                    icon: Icon(Icons.add),
                                    label: Text('Click to add an entry'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WriteDiaryDialog(
                                              selectedDate: selectedDate,
                                              titleTextController:
                                                  _titleTextController,
                                              descriptionTextController:
                                                  _descriptionTextController);
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ))
      ],
    );
  }
}
