import 'package:ajanda_flutter/model/Diary.dart';
import 'package:ajanda_flutter/model/user.dart';
import 'package:ajanda_flutter/services/service.dart';
import 'package:ajanda_flutter/widgets/create_profile.dart';
import 'package:ajanda_flutter/widgets/diary_list_view.dart';
import 'package:ajanda_flutter/widgets/write_diary_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// ana sayfa

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;
  DateTime selectedDate = DateTime.now();
  var userDiaryFilteredEntriesList;

  @override
  Widget build(BuildContext context) {
    final _titleTextController = TextEditingController();
    final _descriptionTextController = TextEditingController();
    var _listOfDiaries = Provider.of<List<Diary>>(context);
    var _user = Provider.of<User?>(context);
    var latestFilteredDiariesStrem;
    var earliestFilteredDiariesStrem;

    return Scaffold(
      // Üst Başlık
      appBar: AppBar(
        //Arka plan ve boyut
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        //Logo
        title: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Text(
                'Make',
                style: TextStyle(fontSize: 35, color: Colors.grey.shade800),
              ),
              Text(
                ' A Plan',
                style: TextStyle(fontSize: 35, color: Colors.deepPurple),
              )
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              //En erken en geç seçim butonu
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Earliest', 'Latest'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.deepPurple),
                        ));
                  }).toList(),
                  hint: (_dropDownText == null)
                      ? Text('Select')
                      : Text(_dropDownText!,
                          style: TextStyle(color: Colors.deepPurple)),
                  onChanged: (value) {
                    if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      earliestFilteredDiariesStrem =
                          DiaryService().getEarliestDiaries(_user!.uid);
                      earliestFilteredDiariesStrem.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    } else if (value == "Latest") {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      latestFilteredDiariesStrem =
                          DiaryService().getLatestDiaries(_user!.uid);
                      latestFilteredDiariesStrem.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 100,
              ),
              //Profil Ekranı
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final usersListStream = snapshot.data!.docs.map((docs) {
                    return MUser.fromDocument(docs);
                  }).where((muser) {
                    return (muser.uid ==
                        FirebaseAuth.instance.currentUser!.uid);
                  }).toList();
                  MUser curUser = usersListStream[0];
                  return CreateProfile(curUser: curUser);
                },
              ),
            ],
          )
        ],
      ),
      // Sayfanın body kısmı ikiye bölündü
      body: Row(
        children: [
          // Bir parçası
          Container(
            width: 400,
            child: Expanded(
                flex: 2,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border(
                          right: BorderSide(width: 0.4, color: Colors.grey))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: SfDateRangePicker(
                          onSelectionChanged: (dateRangePickerSelection) {
                            setState(() {
                              selectedDate = dateRangePickerSelection.value;
                              _listOfDiaries.clear();
                              userDiaryFilteredEntriesList = DiaryService()
                                  .getSameDateDiaries(
                                      Timestamp.fromDate(selectedDate).toDate(),
                                      FirebaseAuth.instance.currentUser!.uid);
                              userDiaryFilteredEntriesList.then((value) {
                                for (var item in value) {
                                  setState(() {
                                    _listOfDiaries.add(item);
                                  });
                                }
                              });
                            });
                          },
                        ),
                      ),
                      Container(
                          width: 300,
                          child: Card(
                            elevation: 4,
                            child: TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.deepPurple,
                              ),
                              label: Text(
                                'Write New',
                                style: TextStyle(fontSize: 17),
                              ),
                              onPressed: () {
                                // Write new'e basınca açılan yeni görev ekleme alanı
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
                            ),
                          ))
                    ],
                  ),
                )),
          ),
          //diğer parçası
          Expanded(
              flex: 10,
              child: DiaryListView(
                  listOfDiaries: _listOfDiaries, selectedDate: selectedDate))
        ],
      ),
      // alttaki + butonu
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return WriteDiaryDialog(
                    selectedDate: selectedDate,
                    titleTextController: _titleTextController,
                    descriptionTextController: _descriptionTextController);
              },
            );
          },
          tooltip: 'Add',
          child: Icon(
            Icons.add,
          )),
    );
  }
}
