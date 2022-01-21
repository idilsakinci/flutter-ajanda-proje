import 'package:ajanda_flutter/model/user.dart';
import 'package:ajanda_flutter/pages/login_page.dart';
import 'package:ajanda_flutter/services/service.dart';
import 'package:ajanda_flutter/widgets/update_user_profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({
    Key? key,
    required this.curUser,
  }) : super(key: key);

  final MUser curUser;

  @override
  Widget build(BuildContext context) {
    final _avatarUrlTextController =
        TextEditingController(text: curUser.avatarUrl);
    final _displayNameTextController =
        TextEditingController(text: curUser.displayName);

    return Container(
      child: Row(
        children: [
          //Kullanıcı iconu
          Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(curUser.avatarUrl!),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfileDialog(
                            curUser: curUser,
                            avatarUrlTextController: _avatarUrlTextController,
                            displayNameTextController:
                                _displayNameTextController);
                      },
                    );
                  },
                ),
              ),
              Text(
                curUser.displayName!,
                style: TextStyle(color: Colors.grey.shade800),
              )
            ],
          ),
          SizedBox(
            width: 50,
          ),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                });
              },
              icon: Icon(
                Icons.login_outlined,
                size: 20,
                color: Colors.redAccent,
              ))
        ],
      ),
    );
  }
}
