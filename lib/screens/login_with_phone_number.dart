import 'package:apple_ui/screens/login_page.dart';
import 'package:apple_ui/screens/verify_code.dart';
import 'package:apple_ui/ui/button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  final SnakBarKey = GlobalKey<ScaffoldMessengerState>();
  bool loading = false;
  String countryvalue = '';

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
    String fullphonenumber = '+' + countryvalue + phonecontroller.text;

    print("$fullphonenumber");
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullphonenumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnakBar("$e");
          setState(() {
            loading = false;
          });
        },
        codeSent: (String verificationId, int? token) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyPhoneNumber(verificationIddd: verificationId)));
        },
        codeAutoRetrievalTimeout: (e) {
          showSnakBar("$e");
          setState(() {
            loading = false;
          });
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
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage("assets/images/login_with_phone.png"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Verify Your Number",
                        style: GoogleFonts.alatsi(
                            fontSize: 22,
                            color: Color.fromARGB(255, 61, 50, 204)),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Please enter your country and your phone number.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.alatsi(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 1),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    controller: countrycontroller,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: TextButton(
                                          onPressed: () {
                                            showCountryPicker(
                                              favorite: ['PK'],
                                              countryListTheme:
                                                  CountryListThemeData(
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      bottomSheetHeight: 400,
                                                      flagSize: 20,
                                                      inputDecoration: InputDecoration(
                                                          hintText:
                                                              'Enter Country Name',
                                                          labelText:
                                                              'Search Country'),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(5),
                                                        topLeft:
                                                            Radius.circular(5),
                                                      )),
                                              context: context,
                                              onSelect: (Country country) {
                                                countryvalue = country.phoneCode;
                                                setState(() {});
                                              },
                                            );
                                          },
                                          child: Text(
                                            "+$countryvalue",
                                          ),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    "|",
                                    style: TextStyle(
                                        fontSize: 35,
                                        color:
                                            Color.fromARGB(255, 104, 102, 102)),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: phonecontroller,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Phone',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyButoon(
                          loading: loading,
                          title: 'Request OTP',
                          onPressed: () {
                            LoginWithNumbe();
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account?",
                            style: GoogleFonts.alatsi(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.alatsi(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 61, 50, 204)),
                              ))
                        ],
                      )
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
