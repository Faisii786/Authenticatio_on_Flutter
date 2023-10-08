import 'package:apple_ui/screens/dashboard.dart';
import 'package:apple_ui/screens/login_page.dart';
import 'package:apple_ui/screens/login_with_phone_number.dart';
import 'package:apple_ui/screens/registration_page.dart';
import 'package:apple_ui/ui/button.dart';
import 'package:apple_ui/ui/login_with_social.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  GoogleSignIn GoogleAuth = GoogleSignIn();
  bool loading = false;
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

        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } catch (e) {
      showSnakBar(e.toString());
    }
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
    return SafeArea(
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
                    Image.asset(
                      "assets/images/flower.png",
                      width: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Wellcome Message
                    Text(
                      "Wellcome Back !",
                      style: GoogleFonts.akshar(fontSize: 22),
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
                        title: 'Continue with Facebook',
                        onPressed: () {},
                        image: AssetImage("assets/images/facebook.png")),

                    SizedBox(
                      height: 10,
                    ),
                    MySocialButton(
                        title: 'Continue with phone no',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginWithPhoneNumber()));
                        },
                        image: AssetImage("assets/images/phone.png")),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Or",
                          style: GoogleFonts.alatsi(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Create Account
                    MyButoon(
                      loading: loading,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                      },
                      title: 'Create Account',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 300,
                      child: Text(
                        "By signing up,You agree to the Terms of Service and Privacy policy, including cccokies use",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have a account?",
                          style: GoogleFonts.alatsi(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
