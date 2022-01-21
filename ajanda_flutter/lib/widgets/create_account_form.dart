import 'package:ajanda_flutter/model/user.dart';
import 'package:ajanda_flutter/pages/main_page.dart';
import 'package:ajanda_flutter/services/service.dart';
import 'package:ajanda_flutter/widgets/input_decorator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key? key,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
    GlobalKey<FormState>? formKey,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _globalKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign Up',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
              'Please enter a valid e-mail and password that is at least 6 character.'),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter an e-mail' : null;
              },
              controller: _emailTextController,
              decoration: buildInputDecoration('e-mail', 'idil@gmail.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter a password' : null;
              },
              obscureText: true,
              controller: _passwordTextController,
              decoration: buildInputDecoration('password', ''),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  backgroundColor: Colors.deepPurple,
                  textStyle: TextStyle(fontSize: 15)),
              onPressed: () {
                if (_globalKey!.currentState!.validate()) {
                  // idil@gmail.com [idil, gmail.com]
                  String email = _emailTextController.text;

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: _passwordTextController.text)
                      .then((value) {
                    if (value.user != null) {
                      String uid = value.user!.uid;
                      DiaryService()
                          .createUser(email.split('@')[0], context, uid)
                          .then((value) {
                        DiaryService()
                            .loginUser(email, _passwordTextController.text)
                            .then((value) {
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(),
                              ));
                        });
                      });
                    }
                  });
                }
              },
              child: Text('Sign Up'))
        ],
      ),
    );
  }
}
