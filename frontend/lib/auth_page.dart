import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceMeAuthPage extends StatefulWidget {
  const PlaceMeAuthPage({super.key});

  @override
  State<PlaceMeAuthPage> createState() => _PlaceMeAuthPageState();
}

class _PlaceMeAuthPageState extends State<PlaceMeAuthPage> {
  String? errorMessage = ApplicationState().errorMessage;
  bool isLogin = true;
  final String registerEndpoint = 'http://172.16.0.189:5000/api/users/signup';
  final String signInEndpoint = 'http://172.16.0.189:5000/api/users/login';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

  bool _isRegistering = false;
  bool _isSigningIn = false;

  Future<void> signIn() async {
    setState(() {
      _isSigningIn = true;
    });

    final data = {
      'email': _controllerEmail.text,
      'password': _controllerPassword.text,
    };

    try {
      final response = await http.post(
        Uri.parse(signInEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Login successful: $responseData');
        Provider.of<ApplicationState>(context, listen: false).login();
      } else {
        throw Exception('Failed to log in: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> register() async {
    setState(() {
      _isRegistering = true;
    });

    final data = {
      'fullName': _controllerFullName.text,
      'email': _controllerEmail.text,
      'password': _controllerPassword.text,
    };

    try {
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Registration successful: $responseData');
        Provider.of<ApplicationState>(context, listen: false).login();
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
        print('Error during registration: $e');
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerFullName.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textStyle = AppStyles.textStyle;
    final formStyle = AppStyles.formStyle;
    final buttonStyle = AppStyles.buttonStyle;

    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth > 450 ? 600 : 45;

    Widget progressIndicator = AppStyles().progressIndicator;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: padding, bottom: 15),
                        child: Text(
                          isLogin ? 'sign in' : 'register',
                          style: const TextStyle(
                            fontFamily: 'Roboto Flex',
                            color: Color(0xFF3A2C59),
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'placeMe',
                          style: TextStyle(
                            fontFamily: 'Roboto Flex',
                            color: Color(0xFF3A2C59),
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 18),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(padding, 4, padding, 12),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Visibility(
                                  visible: !isLogin,
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
                                      ),
                                      child: TextFormField(
                                        controller: _controllerFullName,
                                        decoration: formStyle.copyWith(hintText: 'full name'),
                                        style: textStyle.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xC82B1A4E),
                                        ),
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: TextFormField(
                                      controller: _controllerEmail,
                                      decoration: formStyle.copyWith(hintText: 'email'),
                                      style: textStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xC82B1A4E),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: TextFormField(
                                      controller: _controllerPassword,
                                      decoration: formStyle.copyWith(hintText: 'password'),
                                      obscureText: true,
                                      style: textStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xC82B1A4E),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Visibility(
                                  visible: !isLogin,
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
                                      ),
                                      child: TextFormField(
                                        controller: _controllerConfirmPassword,
                                        decoration: formStyle.copyWith(hintText: 'confirm password'),
                                        obscureText: true,
                                        style: textStyle.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xC82B1A4E),
                                        ),
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Reset error message before any validation
                                    setState(() {
                                      errorMessage = '';
                                    });

                                    // Validate full name for registration
                                    if (!isLogin && _controllerFullName.text.isEmpty) {
                                      setState(() {
                                        errorMessage = 'Full name field cannot be empty! Please try again.';
                                      });
                                      return;  // Early return to prevent further execution
                                    }

                                    // Validate password presence
                                    if (_controllerPassword.text.isEmpty) {
                                      setState(() {
                                        errorMessage = 'Please provide a password and try again.';
                                      });
                                      return;  // Early return to prevent further execution
                                    }

                                    // Check if password and confirm password match for registration
                                    if (!isLogin && _controllerPassword.text != _controllerConfirmPassword.text) {
                                      setState(() {
                                        errorMessage = 'Passwords do not match! Please try again.';
                                      });
                                      return;  // Early return to prevent further execution
                                    }

                                    // If form is valid and no errors, proceed with registration
                                    if (_formKey.currentState!.validate() && !_isRegistering) {
                                      isLogin ? signIn() : register();  // Perform the registration action
                                    }
                                  },
                                  style: buttonStyle.copyWith(padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 20))),
                                  child: _isRegistering || _isSigningIn ? progressIndicator : Text(isLogin ? 'sign in' : 'register'),
                                ),
                              ),

                            ],
                          )
                      ),
                    ),
                    RichText(text: TextSpan(
                        style: textStyle.copyWith(fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text: isLogin ? 'Not an existing user? Register ' : 'Already have an account? Sign in '
                          ),
                          TextSpan(
                              text: 'here.',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                _controllerEmail.clear();
                                _controllerFullName.clear();
                                _controllerPassword.clear();
                                _controllerConfirmPassword.clear();
                                errorMessage = '';
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              }
                          ),
                        ]
                    )),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        errorMessage == '' ? '' : '$errorMessage',
                        textAlign: TextAlign.center,
                        style: textStyle.copyWith(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}