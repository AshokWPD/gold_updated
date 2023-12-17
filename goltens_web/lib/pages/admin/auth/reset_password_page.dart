import 'package:flutter/material.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  final tokenTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  Future<void> resetPassword() async {
    try {
      if (formKey.currentState?.validate() == true) {
        formKey.currentState?.save();

        await AuthService.resetPassword(
          tokenTextController.text,
          passwordTextController.text,
        );

        final userResponse = await AuthService.getMe();

        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
          navigateToStart(routeName: '/admin/dashboard');
        }
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
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double formWidth = isMobile ? 300.0 : 800.0;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 32.0),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: formWidth,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16.0),
                        const Text(
                          'A token has been sent to your email. Enter it here within 10 '
                              'minutes to reset your password (It may take a few minutes)',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: formWidth,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Token',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            controller: tokenTextController,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter the token sent to your mail';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: formWidth,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'New Password',
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
                                        () => showPassword = !showPassword),
                              ),
                            ),
                            controller: passwordTextController,
                            obscureText: !showPassword,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please enter a new password';
                              }

                              if (value != null && value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: formWidth,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
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
                                        () => showPassword = !showPassword),
                              ),
                            ),
                            controller: confirmPasswordTextController,
                            obscureText: !showPassword,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Please confirm the new password';
                              }

                              if (value != null && value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }

                              if (value != null &&
                                  value != passwordTextController.text) {
                                return 'Password and confirm password must be the same';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: formWidth,
                          child: ElevatedButton.icon(
                            onPressed: resetPassword,
                            icon: const Icon(Icons.done),
                            label: const Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
