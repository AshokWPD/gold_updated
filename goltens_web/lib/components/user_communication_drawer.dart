// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:goltens_web/utils/functions.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

class UserCommunicationDrawer extends StatefulWidget {
  const UserCommunicationDrawer({super.key});

  @override
  State<UserCommunicationDrawer> createState() =>
      _UserCommunicationDrawerState();
}

class _UserCommunicationDrawerState extends State<UserCommunicationDrawer> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(context);
  }

  void setIndex() {
    if (!mounted) return;
    var url = Uri.parse(window.location.href);
    var pageParam = url.queryParameters['page'];
    final user = context.watch<GlobalState>().user?.data;

    setState(() {
      switch (url.path) {
        case '/home':
          selectedIndex = 0;

          switch (pageParam) {
            case 'groups':
              selectedIndex = 0;
              break;
            case 'risk-assessment':
              selectedIndex = 1;
              break;
            case 'other-files':
              selectedIndex = 2;
              break;
            case 'user-orientation':
              selectedIndex = 3;
              break;
          }
          break;
        case '/profile':
          if (user?.type == UserType.subAdmin) {
            selectedIndex = 5;
          } else {
            selectedIndex = 4;
          }
          break;
        case '/master-list':
          selectedIndex = 4;

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

    var items = [
      const SideNavigationBarItem(
        icon: Icons.group,
        label: 'Groups',
      ),
      const SideNavigationBarItem(
        icon: Icons.list_alt_sharp,
        label: 'Risk Assessment',
      ),
      const SideNavigationBarItem(
        icon: Icons.list_alt_sharp,
        label: 'Other Files',
      ),
      const SideNavigationBarItem(
        icon: Icons.list_alt_sharp,
        label: 'User Orientation',
      ),
      const SideNavigationBarItem(
        icon: Icons.edit,
        label: 'Edit Profile',
      ),
      const SideNavigationBarItem(
        icon: Icons.swap_horiz_outlined,
        label: 'Go To Feedback',
      ),
      const SideNavigationBarItem(
        icon: Icons.logout,
        label: 'Logout',
      ),
    ];

    if (user?.type == UserType.subAdmin) {
      items.insert(
        4, // Index
        const SideNavigationBarItem(
          icon: Icons.file_copy_sharp,
          label: 'Master List',
        ),
      );
    }

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
      items: items,
      onTap: (index) async {
        switch (index) {
          case 0:
            setState(() => selectedIndex = 0);
            navigateTo(
              routeName: '/home',
              queryParams: {'page': 'groups'},
            );
            break;
          case 1:
            setState(() => selectedIndex = 1);

            navigateTo(
              routeName: '/home',
              queryParams: {'page': 'risk-assessment'},
            );
            break;
          case 2:
            setState(() => selectedIndex = 2);

            navigateTo(
              routeName: '/home',
              queryParams: {'page': 'other-files'},
            );
            break;
          case 3:
            setState(() => selectedIndex = 3);

            navigateTo(
              routeName: '/home',
              queryParams: {'page': 'user-orientation'},
            );
            break;
          case 4:
            if (user?.type == UserType.subAdmin) {
              setState(() => selectedIndex = 4);
              navigateTo(routeName: '/master-list');
            } else {
              setState(() => selectedIndex = 4);
              navigateTo(routeName: '/profile');
            }
            break;
          case 5:
            if (user?.type == UserType.subAdmin) {
              setState(() => selectedIndex = 5);
              navigateTo(routeName: '/profile');
            } else {
              navigateTo(routeName: '/feedback');
            }
            break;

          case 6:
            if (user?.type == UserType.subAdmin) {
              navigateTo(routeName: '/feedback');
            } else {
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
            }

            break;
          case 7:
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
