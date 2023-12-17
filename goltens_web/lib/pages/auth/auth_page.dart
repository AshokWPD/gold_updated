import 'dart:html';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:goltens_web/utils/functions.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginForm = true;
  bool isLoading = false;
  bool showPassword = false;
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final departmentController = SingleValueDropDownController();
  final employeeNumberTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      try {
        var userResponse = await AuthService.getMe();

        if (userResponse.data.type == UserType.admin) {
          navigateToStart(routeName: '/admin');
          return;
        }

        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
        }

        // Only redirect if an authenticated user comes to login again
        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
          redirect();
        }
      } catch (e) {
        if (mounted) {
          context.read<GlobalState>().setUserResponse(null);
          authNavigate(context);
        }
      }
    });
  }

  void redirect() {
    var url = window.location.href.split("/").last;
    var user = context.read<GlobalState>().user;

    if (url == '' && user != null) {
      navigateToStart(routeName: '/choose-app');
    }
  }

  Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;
    final isTablet = MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width <= 1200;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              minWidth: isDesktop ? 400 : 300,
              maxWidth: isDesktop ? 450 : 400,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: buildHeader() + buildInputs() + buildButtons(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildHeader() {
    return [
      const SizedBox(height: 20.0),
      Image.asset('assets/images/logo.png', width: 80.0, height: 80.0),
      const SizedBox(height: 20.0),
      if (isLoginForm)
        Image.asset('assets/images/register.jpg', height: 300.0)
      else
        Image.asset('assets/images/login.jpg', height: 300.0),
      const SizedBox(height: 20.0)
    ];
  }

  List<Widget> buildInputs() {
    return [
      if (!isLoginForm)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextFormField(
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            controller: nameTextController,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter your name';
              }

              return null;
            },
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          controller: emailTextController,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter your email address';
            }

            return null;
          },
        ),
      ),
      if (!isLoginForm)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: IntlPhoneField(
            decoration: InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            initialCountryCode: singaporeCountryCode,
            onChanged: (phone) {
              phoneTextController.text = phone.completeNumber;
            },
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value != null && value.completeNumber.isEmpty) {
                return 'Please enter your phone number';
              }

              try {
                value?.isValidNumber();
                return null;
              } on Exception {
                return 'Invalid Number';
              }
            },
          ),
        ),
      if (!isLoginForm)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DropDownTextField(
            clearOption: false,
            controller: departmentController,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please select your department';
              }
              return null;
            },
            textFieldDecoration: InputDecoration(
              labelText: 'Department',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            dropDownItemCount: departmentList.length,
            dropDownList: departmentList.map((department) {
              return DropDownValueModel(name: department, value: department);
            }).toList(),
          ),
        ),
      if (!isLoginForm)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Employee Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            controller: employeeNumberTextController,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter your employee number';
              }
              return null;
            },
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                !showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => showPassword = !showPassword),
            ),
          ),
          controller: passwordTextController,
          obscureText: !showPassword,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter a password';
            }

            if (value != null && value.length < 6) {
              return 'Password must be at least 6 characters long';
            }

            return null;
          },
        ),
      ),
    ];
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
        navigateTo(routeName: '/reset-password');
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  List<Widget> buildButtons() {
    if (isLoginForm) {
      return [
        ElevatedButton(
          onPressed: !isLoading
              ? () async {
            if (formKey.currentState?.validate() == true) {
              formKey.currentState?.save();
              setState(() => isLoading = true);

              try {
                final fcmToken = await getFcmToken();

                await AuthService.login(
                  email: emailTextController.text,
                  password: passwordTextController.text,
                  fcmToken: fcmToken,
                );

                if (mounted) authNavigate(context);
              } catch (e) {
                if (mounted) {
                  final snackBar = SnackBar(content: Text(e.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } finally {
                setState(() => isLoading = false);
              }
            }
          }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            minimumSize: const Size(
              double.infinity,
              40.0,
            ),
          ),
          child: !isLoading
              ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login),
              SizedBox(width: 5),
              Text('Login'),
            ],
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 30,
          child: TextButton(
            onPressed: forgotPassword,
            child: const Text('Forgot Password'),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 30,
          child: TextButton(
            onPressed: () {
              navigateTo(routeName: '/admin');
            },
            child: const Text('Administrator Login'),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 30,
          child: TextButton(
            child: const Text('Don\'t have an account? Register'),
            onPressed: () => setState(() => isLoginForm = false),
          ),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: !isLoading
              ? () async {
            if (formKey.currentState?.validate() == true) {
              formKey.currentState?.save();
              setState(() => isLoading = true);

              try {
                final fcmToken = await getFcmToken();

                await AuthService.register(
                  name: nameTextController.text,
                  email: emailTextController.text,
                  phone: phoneTextController.text,
                  password: passwordTextController.text,
                  department: departmentController.dropDownValue?.value,
                  employeeNumber: employeeNumberTextController.text,
                  fcmToken: fcmToken,
                );

                if (mounted) authNavigate(context);
              } catch (e) {
                if (mounted) {
                  final snackBar = SnackBar(content: Text(e.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } finally {
                setState(() => isLoading = false);
              }
            }
          }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: !isLoading
              ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle),
              SizedBox(width: 5),
              Text('Register'),
            ],
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        TextButton(
          child: const Text('Already have an account? Login'),
          onPressed: () => setState(() => isLoginForm = true),
        ),
        const SizedBox(height: 15),
      ];
    }
  }
}
