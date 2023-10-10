import 'package:apple_ui/screens/dashboard.dart';
import 'package:apple_ui/screens/forget_password.dart';
import 'package:apple_ui/screens/login_with_phone_number.dart';
import 'package:apple_ui/screens/terms_and_condition.dart';
import 'package:apple_ui/ui/button.dart';
import 'package:apple_ui/ui/login_with_social.dart';
import 'package:apple_ui/ui/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn GoogleAuth = GoogleSignIn();

  GlobalKey<FormState> MyKey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool loading = false;

  void ValidateFunction() {
    if (emailcontroller.text.isEmpty) {
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
      Login();
    }
  }

  Future Login() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
      emailcontroller.clear();
      passwordcontroller.clear();
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        showSnakBar(
            "Invalid Credentials ! Please enter valid email and password");
      } else if (e.code == 'user-not-found') {
        showSnakBar("Email does not foud");
      } else if (e.code == 'wrong-password') {
        showSnakBar("Password is incorrect");
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleAuth.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        showSnakBar("Login Successfull");
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } catch (e) {
      showSnakBar(e.toString());
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
      onWillPop: () async{
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
                      SizedBox(
                        height: 10,
                      ),
                      //lock icon
                      Icon(
                        Icons.lock,
                        size: 60,
                      ),
    
                      SizedBox(
                        height: 20,
                      ),
    
                      // Wellcome Message
                      Text(
                        "Wellcome Back ! Please Login",
                        style: GoogleFonts.akshar(fontSize: 22),
                      ),
    
                      //Textfiled
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: MyKey,
                          child: Column(
                            children: [
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
                        height: 10,
                      ),
    
                      //Forget passoword
                      Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                child: Text(
                                  "Forget Password?",
                                  style: GoogleFonts.alatsi(),
                                )),
                          ],
                        ),
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
                        title: 'Login',
                      ),
    
                      SizedBox(
                        height: 10,
                      ),
    
                      MySocialButton(
                          title: 'Continue with Google',
                          onPressed: () {
                            loginWithGoogle();
                          },
                          image: AssetImage("assets/images/google.png")),
    
                      SizedBox(
                        height: 10,
                      ),
                      MySocialButton(
                          title: 'Continue With Facebook',
                          onPressed: () {},
                          image: AssetImage("assets/images/facebook.png")),
    
                      SizedBox(
                        height: 10,
                      ),
                      MySocialButton(
                          title: 'Continue With phone no',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginWithPhoneNumber()));
                          },
                          image: AssetImage("assets/images/phone.png")),
                      SizedBox(
                        height: 20,
                      ),
    
                      // Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member?",
                            style: GoogleFonts.alatsi(
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsAndConditions()));
                              },
                              child: Text(
                                "Register",
                                style: GoogleFonts.braahOne(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 46, 11, 105)),
                              ))
                        ],
                      ),
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
