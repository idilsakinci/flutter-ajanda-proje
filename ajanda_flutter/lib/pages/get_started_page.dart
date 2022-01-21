import 'package:flutter/material.dart';
import 'login_page.dart';


class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor:
            Colors.deepPurple.shade50, // Color(0XFFE6E6FA) lavanta,
        child: Column(
          children: [
            Spacer(),
            Text('Make A Plan', style: Theme.of(context).textTheme.headline3),
            SizedBox(
              height: 40,
            ),
            Text(
              '"Plan your life"',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black38),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 220,
              height: 40,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.login_rounded),
                label: Text('Get Started'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
