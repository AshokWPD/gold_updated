import 'package:flutter/material.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/utils/functions.dart';

class UserResetPasswordPage extends StatefulWidget {
  const UserResetPasswordPage({Key? key});

  @override
  State<UserResetPasswordPage> createState() => _UserResetPasswordPageState();
}

class _UserResetPasswordPageState extends State<UserResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  final tokenTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double formWidth = isMobile ? 300.0 : 800.0;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(16.0),
            child: buildBody(formWidth),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      if (formKey.currentState?.validate() == true) {
        formKey.currentState?.save();

        await AuthService.resetPassword(
          tokenTextController.text,
          passwordTextController.text,
        );

        if (mounted) authNavigate(context);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget buildBody(double formWidth) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Reset Password',
            style: TextStyle(fontSize: 32.0),
            textAlign: TextAlign.center,
          ),
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
                    !showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => showPassword = !showPassword),
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
                    !showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => showPassword = !showPassword),
                ),
              ),
              controller: confirmPasswordTextController,
              obscureText: !showPassword,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter confirm new password';
                }

                if (value != null && value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }

                if (value != null && value != passwordTextController.text) {
                  return 'Password and confirm password must be the same';
                }

                return null;
              },
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: resetPassword,
            icon: const Icon(Icons.done),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
