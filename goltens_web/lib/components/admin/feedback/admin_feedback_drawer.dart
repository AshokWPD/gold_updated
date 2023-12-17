// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:provider/provider.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_core/services/auth.dart';

class AdminFeedbackDrawer extends StatefulWidget {
  const AdminFeedbackDrawer({Key? key}) : super(key: key);

  @override
  State<AdminFeedbackDrawer> createState() => _AdminFeedbackDrawerState();
}

class _AdminFeedbackDrawerState extends State<AdminFeedbackDrawer> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        var userResponse = await AuthService.getMe();

        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
        }
      } catch (e) {
        if (mounted) {
          context.read<GlobalState>().setUserResponse(null);
          navigateToStart(routeName: '/admin');
        }
      }
    });
  }

  void setIndex() {
    var url = Uri.parse(window.location.href);

    setState(() {
      switch (url.path) {
        case '/admin/feedback-dashboard':
          selectedIndex = 0;
          break;
        case '/admin/feedbacks':
          selectedIndex = 1;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<GlobalState>().user;
    var isLoading = context.watch<GlobalState>().isLoading;
    var isTablet = MediaQuery.of(context).size.width < 800;
    setIndex();

    return !isLoading
        ? Row(
            children: [
              SideNavigationBar(
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
                      child: user?.data.avatar.isNotEmpty == true
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                '$apiUrl/$avatar/${user?.data.avatar}',
                                errorBuilder: (
                                  context,
                                  obj,
                                  stacktrace,
                                ) {
                                  return Container();
                                },
                              ),
                            )
                          : Text(user?.data.name[0] ?? '---'),
                    ),
                  ),
                  title: Text(user?.data.name ?? ''),
                  subtitle: Container(),
                ),
                footer: const SideNavigationBarFooter(
                  label: Text(
                    'Goltens Admin Panel',
                    textAlign: TextAlign.center,
                  ),
                ),
                selectedIndex: selectedIndex,
                items: const [
                  SideNavigationBarItem(
                    icon: Icons.dashboard_sharp,
                    label: 'Dashboard',
                  ),
                  SideNavigationBarItem(
                    icon: Icons.done_all,
                    label: 'Feedbacks',
                  ),
                  SideNavigationBarItem(
                    icon: Icons.swap_horiz_outlined,
                    label: 'Go To Communication',
                  ),
                  SideNavigationBarItem(
                    icon: Icons.logout,
                    label: 'Logout',
                  ),
                ],
                onTap: (index) async {
                  switch (index) {
                    case 0:
                      await navigateTo(routeName: '/admin/feedback-dashboard');
                      setIndex();
                      break;
                    case 1:
                      await navigateTo(routeName: '/admin/feedbacks');
                      setIndex();
                      break;
                    case 2:
                      await navigateTo(
                          routeName: '/admin/communication-dashboard');
                      setIndex();
                      break;
                    case 3:
                      if (!mounted) return;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                const Text("Are you sure you want to logout ?"),
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
                                    context
                                        .read<GlobalState>()
                                        .setUserResponse(null);

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
              )
            ],
          )
        : Container();
  }
}
