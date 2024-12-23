import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/authentication/login/login_cubit.dart';
import 'package:smartwatch_companion/authentication/signup/signup_page.dart';

class LogInPage extends StatelessWidget {
  static String get path => "/login";
  static String get name => "login";
  static GoRoute get route => GoRoute(
        path: path,
        name: name,
        builder: (_, __) => LogInPage(),
      );

  LogInPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/smartwatch.jpg',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Smartwatch Companion',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'abc@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LogInCubit>().loginWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.teal[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Forgot Password
                  // GestureDetector(
                  //   onTap: () {
                  //     // Navigate to Forgot Password page
                  //   },
                  //   child: Text(
                  //     'Forgot Password?',
                  //     style: TextStyle(
                  //       color: Colors.teal[700],
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.0,
                        child: Divider(
                          color: Colors.black,
                          endIndent: 8.0,
                        ),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(136, 151, 174, 1),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                        child: Divider(
                          color: Colors.black,
                          indent: 8.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  TextButton.icon(
                    onPressed: () {
                      context.read<LogInCubit>().loginWithGoogle();
                    },
                    icon: Image.asset(
                      'assets/google_logo.png',
                      height: 20.0,
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ButtonStyle(
                        // fixedSize: WidgetStateProperty.all(
                        //   Size(size.width, size.width * 0.16),
                        // ),
                        // shape: WidgetStateProperty.all(
                        //   const StadiumBorder(
                        //     side: BorderSide(color: Colors.teal),
                        //   ),
                        // ),
                        ),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don’t have an account?'),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => context.go(SignUpPage.path),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
