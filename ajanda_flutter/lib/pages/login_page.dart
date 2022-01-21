import 'package:ajanda_flutter/widgets/create_account_form.dart';
import 'package:ajanda_flutter/widgets/input_decorator.dart';
import 'package:ajanda_flutter/widgets/login_form.dart';
import 'package:flutter/material.dart';

// giriş ve kayıt olma sayfası

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState>? _globalKey = GlobalKey<FormState>();
  bool isCreatedAccountClicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.deepPurple.shade50,
                )),
            SizedBox(
              height: 10,
            ),
            Column(
              // sign in ve sign up arasında geçiş ayarlandı
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: isCreatedAccountClicked
                      ? CreateAccountForm(
                          formKey: _globalKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController)
                      : LoginForm(
                          formKey: _globalKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController),
                ),
                TextButton.icon(
                  icon: Icon(Icons.portrait_rounded),
                  label: Text(
                    isCreatedAccountClicked
                        ? 'Do you already have an account?'
                        : 'Create Account',
                  ),
                  style: TextButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                  onPressed: () {
                    setState(() {
                      if (!isCreatedAccountClicked) {
                        isCreatedAccountClicked = true;
                      } else {
                        isCreatedAccountClicked = false;
                      }
                    });
                  },
                )
              ],
            ),
            Expanded(
                flex: 2,
                child: Container(
                  color: Colors.deepPurple.shade50,
                ))
          ],
        ),
      ),
    );
  }
}
