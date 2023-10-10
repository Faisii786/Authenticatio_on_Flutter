import 'package:apple_ui/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { 
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  });
                },
                icon: Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
}
