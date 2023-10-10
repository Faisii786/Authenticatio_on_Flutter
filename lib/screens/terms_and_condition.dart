import 'package:apple_ui/screens/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool checkboxstate = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { 
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "I Agree",
                          style: GoogleFonts.alatsi(fontSize: 20),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              fillColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.deepPurple;
                                }
                                return null;
                              }),
                              checkColor: Colors.white,
                              value: checkboxstate,
                              onChanged: (value) {
                                setState(() {
                                  checkboxstate = value!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 5),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                            onPressed: checkboxstate
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  }
                                : null,
                            child: Center(child: Text("Next"))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Terms and Conditions",
                  style: GoogleFonts.alatsi(fontSize: 22),
                ),
                Text(
                  // Your terms and conditions text here
                  "By signing in, you agree to our terms and conditions...",
                  style: GoogleFonts.alatsi(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
