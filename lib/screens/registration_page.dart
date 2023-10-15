import 'package:apple_ui/screens/login_page.dart';
import 'package:apple_ui/ui/button.dart';
import 'package:apple_ui/ui/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> MyKey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool loading = false;

  void ValidateFunction() {
    if (firstnamecontroller.text.isEmpty) {
      showSnakBar("First name is empty");
    } else if (lastnamecontroller.text.isEmpty) {
      showSnakBar("Last name is empty");
    } else if (emailcontroller.text.isEmpty) {
      showSnakBar("Email is Empty");
      return;
    } else if (!isValidEmail(emailcontroller.text)) {
      showSnakBar("Please Enter a valid email");
    } else if (passwordcontroller.text.isEmpty) {
      showSnakBar("Password is Empty");
      return;
    } else if (passwordcontroller.text.length < 8) {
      showSnakBar("Password must at least 8");
      return;
    } else {
      Register();
    }
  }

  Future Register() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      showSnakBar("Account Created Successfully");
      emailcontroller.clear();
      passwordcontroller.clear();
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("Error creating account: $e");
      showSnakBar("Failed to create account: $e");
      print('$e');
    }
  }

  // Function to validate email using a regular expression
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  // snackbar function
  void showSnakBar(String message) {
    final snakbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 4),
    );
    SnakBarKey.currentState?.showSnackBar(snakbar);
  }

  final SnakBarKey = GlobalKey<ScaffoldMessengerState>();
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
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      //lock icon
                      Icon(
                        Icons.lock,
                        size: 60,
                      ),
                  
                      SizedBox(
                        height: 30,
                      ),
                  
                      // wellcome message
                      Text(
                        "Please Create Your Account",
                        style: GoogleFonts.akshar(fontSize: 22),
                      ),
                  
                      //Textfiled
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                          key: MyKey,
                          child: Column(
                            children: [
                              MyTextField(
                                  controller: firstnamecontroller,
                                  hinttext: 'First Name'),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                  controller: lastnamecontroller,
                                  hinttext: 'Last Name'),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                  controller: emailcontroller, hinttext: 'Email'),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                  controller: passwordcontroller,
                                  hinttext: 'Password'),
                            ],
                          )),
                  
                      SizedBox(
                        height: 5,
                      ),
                  
                      SizedBox(
                        height: 10,
                      ),
                  
                      //Login button
                      MyButoon(
                        loading: loading,
                        onPressed: () {
                          ValidateFunction();
                        },
                        title: 'Register',
                      ),
                  
                      SizedBox(
                        height: 50,
                      ),
                  
                      // Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account?",
                            style: GoogleFonts.braahOne(
                              fontSize: 16,
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
                                style: GoogleFonts.braahOne(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 46, 11, 105)),
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
