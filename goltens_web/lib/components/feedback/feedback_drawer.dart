// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/feedback.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_core/services/feedback.dart';
import 'package:goltens_web/pages/auth/auth_page.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

class FeedbackDrawer extends StatefulWidget {
  const FeedbackDrawer({super.key});

  @override
  State<FeedbackDrawer> createState() => _FeedbackDrawerState();
}

class _FeedbackDrawerState extends State<FeedbackDrawer> {
  FeedbackDrawerData? drawerData;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchDrawerData();
  }

  Future<void> fetchDrawerData() async {
    try {
      var res = await FeedbackService.getFeedbackDrawerData();

      setState(() {
        drawerData = res.data;
      });
    } catch (err) {
      // Empty
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    BuildContext context,
  ) async {
    try {
      await AuthService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      var userResponse = await AuthService.getMe();

      if (mounted) {
        const snackBar = SnackBar(
          content: Text('Password Changed Successfully'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.read<GlobalState>().setUserResponse(userResponse);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        var formKey = GlobalKey<FormState>();
        final currentPasswordTextController = TextEditingController();
        final newPasswordTextController = TextEditingController();
        bool showPassword = false;

        return AlertDialog(
          title: const Center(child: Text("Change Password")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 215,
                width: 410,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Current Password',
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
                              controller: currentPasswordTextController,
                              obscureText: !showPassword,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter new password';
                                }

                                if (value != null && value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
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
                                    () => showPassword = !showPassword,
                                  ),
                                ),
                              ),
                              controller: newPasswordTextController,
                              obscureText: !showPassword,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter new password';
                                }

                                if (value != null && value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.done),
                        label: const Text('Change Password'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();

                            await changePassword(
                              currentPasswordTextController.text,
                              newPasswordTextController.text,
                              context,
                            );

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void logout() {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want to logout ?"),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                await AuthService.logout();

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void setIndex() {
    if (!mounted) return;
    var url = Uri.parse(window.location.href);

    setState(() {
      switch (url.path) {
        case '/feedback':
          selectedIndex = 0;
          break;
        case '/feedback-dashboard':
          selectedIndex = 1;
          break;
        case '/feedback-assigned':
          selectedIndex = 2;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalState>().user?.data;
    var isTablet = MediaQuery.of(context).size.width < 800;
    setIndex();

    return SideNavigationBar(
      expandable: !isTablet,
      initiallyExpanded: !isTablet,
      theme: SideNavigationBarTheme(
        backgroundColor: Colors.white,
        togglerTheme: SideNavigationBarTogglerTheme.standard(),
        dividerTheme: SideNavigationBarDividerTheme.standard(),
        itemTheme: SideNavigationBarItemTheme(
          selectedBackgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Colors.black,
        ),
      ),
      header: SideNavigationBarHeader(
        image: Material(
          borderRadius: BorderRadius.circular(60),
          elevation: 8,
          child: CircleAvatar(
            child: user?.avatar.isNotEmpty == true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      '$apiUrl/$avatar/${user?.avatar}',
                      errorBuilder: (
                        context,
                        obj,
                        stacktrace,
                      ) {
                        return Container();
                      },
                    ),
                  )
                : Text(user?.name[0] ?? '---'),
          ),
        ),
        title: Text(user?.name ?? ''),
        subtitle: Container(),
      ),
      footer: const SideNavigationBarFooter(
        label: Text(
          'Goltens Application',
          textAlign: TextAlign.center,
        ),
      ),
      selectedIndex: selectedIndex,
      items: [
        const SideNavigationBarItem(
          icon: Icons.group,
          label: 'Feedback',
        ),
        const SideNavigationBarItem(
          icon: Icons.list_alt_sharp,
          label: 'Dashboard',
        ),
        SideNavigationBarItem(
          icon: Icons.list_alt_sharp,
          label: 'Assigned Feedbacks (${drawerData?.assignedFeedbacks ?? "-"})',
        ),
        const SideNavigationBarItem(
          icon: Icons.list_alt_sharp,
          label: 'Change Password',
        ),
        const SideNavigationBarItem(
          icon: Icons.swap_horiz_outlined,
          label: 'Go To Communication',
        ),
        const SideNavigationBarItem(
          icon: Icons.logout,
          label: 'Logout',
        ),
      ],
      onTap: (index) async {
        switch (index) {
          case 0:
            setState(() => selectedIndex = 0);
            navigateTo(routeName: '/feedback');
            break;
          case 1:
            setState(() => selectedIndex = 1);
            navigateTo(routeName: '/feedback-dashboard');
            break;
          case 2:
            setState(() => selectedIndex = 2);
            navigateTo(routeName: '/feedback-assigned');
            break;
          case 3:
            showChangePasswordDialog(context);
            break;
          case 4:
            navigateTo(routeName: '/home');
            break;
          case 5:
            if (!mounted) return;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Are you sure you want to logout ?"),
                  actions: [
                    TextButton(
                      child: const Text("CANCEL"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () async {
                        await AuthService.logout();

                        if (mounted) {
                          context.read<GlobalState>().setUserResponse(null);

                          Navigator.pushReplacementNamed(
                            context,
                            '/',
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
            break;
          default:
        }
      },
    );
  }
}
