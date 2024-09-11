import 'package:book_grocer/firebaseauth.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';  // Import SignInView
import 'package:flutter/material.dart';
import '../../common/color_extenstion.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isStay = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcon = TextEditingController();
    TextEditingController passwordcon = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                    color: TColor.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              RoundTextField(
                controller: txtFirstName,
                hintText: "First & Last Name",
              ),
              const SizedBox(height: 15),
              RoundTextField(
                controller: emailcon,
                hintText: "Email Address",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                controller: txtMobile,
                hintText: "Mobile Phone",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                controller: passwordcon,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 15),
              RoundLineButton(
                title: "Sign Up",
                onPressed: () {
                  createUserWithEmailAndPassword(
                    emailcon.text,
                    passwordcon.text,
                    context,
                  );
                },
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInView()));
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
