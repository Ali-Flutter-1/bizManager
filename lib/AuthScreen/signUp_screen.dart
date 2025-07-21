import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

import '../CustomWidgets/customButton.dart';
import '../CustomWidgets/customTextfield.dart';
import '../CustomWidgets/customToast.dart';
import 'login_screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


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
                  child: Form(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),

                        Center(child: Image.asset('assets/images/img.png',height: 80,width: 80,)),
                        const SizedBox(height: 20),
                        Text(
                          "Create an account",
                          style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Let's create your account.",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF808080),
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Full Name",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          // labelText: 'Full Name',
                          hintText: "Enter your full name",
                          width: size.width,
                          height: 70,
                          controller: usernameController,
                          keyboardType: TextInputType.name,
                          isPassword: false,

                        ),
                        // SizedBox(height: 10.0),
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          // labelText: 'Email',
                          hintText: 'Enter your email address',
                          width: size.width,
                          height: 70,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          isPassword: false,

                        ),
                        // SizedBox(height: 10.0),
                        Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w500),
                        ),
                        CustomTextField(
                          // labelText: 'Password',
                          hintText: 'Enter your password',
                          width: size.width,
                          height: 70,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          isPassword: true,

                        ),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(text: 'By signing up you agree to our '),
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ', '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ',\n'),
                              TextSpan(
                                text: 'and ',
                              ), // line break here
                              TextSpan(
                                text: 'Cookie Use',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        CustomButton(
                          text: "Create an Account",
                          backgroundColor: const Color(0xFFCCCCCC),
                          width: size.width,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            final username = usernameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            // Username validation
                            if (username.isEmpty) {
                              showCustomToast(context, 'Username is required', isError: true);
                              return;
                            }

                            // Email validation
                            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$").hasMatch(email)) {
                              showCustomToast(context, 'Enter a valid Gmail address', isError: true);
                              return;
                            }

                            // Password validation
                            if (password.length < 8) {
                              showCustomToast(context, 'Password must be at least 8 characters long',
                                  isError: true);
                              return;
                            }

                            if (!RegExp(r'[A-Z]').hasMatch(password)) {
                              showCustomToast(context, 'Password must contain an uppercase letter',
                                  isError: true);
                              return;
                            }

                            if (!RegExp(r'[0-9]').hasMatch(password)) {
                              showCustomToast(context, 'Password must contain a number',
                                  isError: true);
                              return;
                            }

                            if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
                              showCustomToast(context, 'Password must contain a special character',
                                  isError: true);
                              return;
                            }
                            // Save signup info (if using Hive for user)
                            // final userBox = Hive.box<>('userBox');
                            // userBox.add(User(name: username, email: email, password: password));

                            final authBox = Hive.box('authBox');
                            authBox.put('isLoggedIn', true);
                            showCustomToast(context, 'Register Successfully');
                            context.go('/dashboard');
                          },
                        ),


                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    context.go('/login');
                                  },
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
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
