import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:goltens_core/models/auth.dart';
import 'dart:html';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPassword = false;
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      try {
        var userResponse = await AuthService.getMe();

        if (userResponse.data.type != UserType.admin) {
          navigateToStart(routeName: '/');
          return;
        }

        // Only redirect if authenticated user comes to login again
        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
          redirect();
        }
      } catch (e) {
        if (mounted) {
          context.read<GlobalState>().setUserResponse(null);
        }
      }
    });
  }

  void redirect() {
    var url = window.location.href.split("/").last;
    var user = context.read<GlobalState>().user;

    if (url == 'admin' && user != null) {
      navigateToStart(routeName: '/admin/app-choose');
    }
  }

  Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      return null;
    }
  }

  void onSubmit() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();
      setState(() => isLoading = true);

      try {
        final fcmToken = await getFcmToken();

        await AuthService.adminLogin(
          email: emailTextController.text,
          password: passwordTextController.text,
          fcmToken: fcmToken,
        );

        var userResponse = await AuthService.getMe();

        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
          Navigator.pushReplacementNamed(context, '/admin/app-choose');
        }
      } catch (e) {
        if (!mounted) return;
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> forgotPassword() async {
    try {
      if (emailTextController.text.isEmpty) {
        if (mounted) {
          const snackBar = SnackBar(content: Text('Enter your email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        return;
      }

      await AuthService.forgotPassword(emailTextController.text);

      if (mounted) {
        navigateTo(routeName: '/admin/reset-password');
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = context.watch<GlobalState>().isLoading;
    var isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
          child: SingleChildScrollView(
            child: !isLoading
                ? Container(
              constraints: BoxConstraints(
                minWidth: isMobile ? 300 : 400,
                maxWidth: isMobile ? 400 : 500,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'images/logo.png',
                          height: isMobile ? 80.0 : 160.0,
                          width: isMobile ? 80.0 : 160.0,
                        ),
                         Text(
                          'Admin Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 24.0 : 32.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                         SizedBox(height: isMobile ? 16.0 : 25.0),
                        TextFormField(
                          controller: emailTextController,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter email';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                         SizedBox(height: isMobile ? 8.0 : 16.0),
                        TextFormField(
                          obscureText: !showPassword,
                          controller: passwordTextController,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter password';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                !showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => setState(
                                    () => showPassword = !showPassword,
                              ),
                            ),
                          ),
                        ),
                         SizedBox(height: isMobile ? 8.0 : 16.0),
                        ElevatedButton(
                          onPressed: !isLoading ? onSubmit : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100.0, 50.0),
                          ),
                          child: !isLoading
                              ? const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 5),
                              Text('Login'),
                            ],
                          )
                              : const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                         SizedBox(height: isMobile ? 12.0 : 35.0),
                        SizedBox(
                          height: isMobile ? 30.0 : 35.0,
                          child: TextButton(
                            onPressed: forgotPassword,
                            child: const Text('Forgot Password'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                : Container(),
          ),
        ),
      ),
    );
  }
}
