import 'package:apple_ui/screens/dashboard.dart';
import 'package:apple_ui/ui/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyPhoneNumber extends StatefulWidget {
  final verificationIddd;
  const VerifyPhoneNumber({super.key, required this.verificationIddd});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController phonecontroller = TextEditingController();
  final SnakBarKey = GlobalKey<ScaffoldMessengerState>();
  bool loading = false;

  // snackbar function
  void showSnakBar(String message) {
    final snakbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 4),
    );
    SnakBarKey.currentState?.showSnackBar(snakbar);
  }

  void LoginWithNumbe() {
    if (phonecontroller.text.isEmpty) {
      showSnakBar("Phone is Empty");
    } else {
      phoneNumber();
    }
  }

  Future phoneNumber() async {
    setState(() {
      loading = true;
    });
    final Credentials = PhoneAuthProvider.credential(
        verificationId: widget.verificationIddd,
        smsCode: phonecontroller.text.toString());

    try {
      await FirebaseAuth.instance.signInWithCredential(Credentials);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      showSnakBar("$e");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { 
        return false;
      },
      child: SafeArea(
        child: ScaffoldMessenger(
          key: SnakBarKey,
          child: Scaffold(
            // appBar: AppBar(
            //   iconTheme: IconThemeData(color: Colors.black),
            //   backgroundColor: Colors.white,
            //   elevation: 0,
            // ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        radius: 70,
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          radius: 60,
                          backgroundImage:
                              AssetImage("assets/images/verify_otp.png"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: TextFormField(
                          controller: phonecontroller,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Enter 6 digit code'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyButoon(
                          loading: loading,
                          title: 'Verify Code',
                          onPressed: () {
                            LoginWithNumbe();
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
