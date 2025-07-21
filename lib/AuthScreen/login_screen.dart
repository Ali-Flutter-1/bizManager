import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:management/AuthScreen/signUp_screen.dart';

import '../CustomWidgets/customButton.dart';
import '../CustomWidgets/customTextfield.dart';
import '../CustomWidgets/customToast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),

                      Center(child: Image.asset('assets/images/img.png',height: 80,width: 80,)),
                      const SizedBox(height: 20),

                      const Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'Font',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "It’s great to see you again.",
                        style: TextStyle(
                        fontFamily: "Font2",
                          fontSize: 16.0,
                          color: Color(0xFF808080),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Font',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Enter your email address',
                        width: size.width,
                        height: 70,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Font',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Enter your password',
                        width: size.width,
                        height: 70,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                      ),

                      const SizedBox(height: 10),

                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Forgot your password? ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Reset your password ',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ForgetPassword(),
                                  //   ),
                                  // );
                                },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 20),

                      CustomButton(
                        text: "Login",
                        backgroundColor: const Color(0xFFCCCCCC),
                        width: size.width,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          if (email.isEmpty || password.isEmpty) {
                            showCustomToast(context, 'Please Enter all Fields',
                                isError: true);
                          } else {
                            final authBox = Hive.box('authBox');
                            authBox.put('isLoggedIn', true);

                            showCustomToast(context, 'Login Successfully');
                            context.go('/dashboard');
                          }
                        },
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don’t have an account? '),
                            GestureDetector(
                              onTap: () {
                                context.go('/signup');

                              },
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
