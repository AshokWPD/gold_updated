// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:provider/provider.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_core/services/auth.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        var userResponse = await AuthService.getMe();

        if (userResponse.data.type != UserType.admin) {
          navigateToStart(routeName: '/');
          return;
        }

        if (mounted) {
          context.read<GlobalState>().setUserResponse(userResponse);
        }
      } catch (e) {
        if (mounted) {
          context.read<GlobalState>().setUserResponse(null);
        }

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  void setIndex() {
    if (!mounted) return;
    var url = window.location.href.split("/").last;

    setState(() {
      switch (url) {
        case 'communication-dashboard':
          selectedIndex = 0;
          break;
        case 'pending-requests':
          selectedIndex = 1;
          break;
        case 'users':
          selectedIndex = 2;
          break;
        case 'subadmins':
          selectedIndex = 3;
          break;
        case 'users-and-subadmins':
          selectedIndex = 4;
          break;
        case 'groups':
          selectedIndex = 5;
          break;
        case 'messages':
          selectedIndex = 6;
          break;
        case 'master-list':
          selectedIndex = 7;
          break;
        case 'risk-assessment':
          selectedIndex = 8;
          break;
        case 'other-file':
          selectedIndex = 9;
          break;
        case 'user-orientation':
          selectedIndex = 10;
          break;
        case 'edit-profile':
          selectedIndex = 11;
          break;
        default:
      }
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   var user = context.read<GlobalState>().user;
  //   var isLoading = context.watch<GlobalState>().isLoading;
  //   var isTablet = MediaQuery.of(context).size.width < 800;
  //   setIndex();
  //
  //   return !isLoading
  //       ? Row(
  //           children: [
  //             SideNavigationBar(
  //               expandable: !isTablet,
  //               initiallyExpanded: !isTablet,
  //               theme: SideNavigationBarTheme(
  //                 backgroundColor: Colors.white,
  //                 togglerTheme: SideNavigationBarTogglerTheme.standard(),
  //                 dividerTheme: SideNavigationBarDividerTheme.standard(),
  //                 itemTheme: SideNavigationBarItemTheme(
  //                   selectedBackgroundColor: Theme.of(context).primaryColor,
  //                   selectedItemColor: Colors.black,
  //                 ),
  //               ),
  //               header: SideNavigationBarHeader(
  //                 image: Material(
  //                   borderRadius: BorderRadius.circular(60),
  //                   elevation: 8,
  //                   child: CircleAvatar(
  //                     child: user?.data.avatar.isNotEmpty == true
  //                         ? ClipRRect(
  //                             borderRadius: BorderRadius.circular(100.0),
  //                             child: Image.network(
  //                               '$apiUrl/$avatar/${user?.data.avatar}',
  //                               errorBuilder: (
  //                                 context,
  //                                 obj,
  //                                 stacktrace,
  //                               ) {
  //                                 return Container();
  //                               },
  //                             ),
  //                           )
  //                         : Text(user?.data.name[0] ?? '---'),
  //                   ),
  //                 ),
  //                 title: Text(user?.data.name ?? ''),
  //                 subtitle: Container(),
  //               ),
  //               footer: const SideNavigationBarFooter(
  //                 label: Text(
  //                   'Goltens Admin Panel',
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //               selectedIndex: selectedIndex,
  //               items: const [
  //                 SideNavigationBarItem(
  //                   icon: Icons.dashboard_sharp,
  //                   label: 'Dashboard',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.done_all,
  //                   label: 'Pending Requests',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.account_circle_rounded,
  //                   label: 'Users',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.manage_accounts,
  //                   label: 'SubAdmins',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.account_tree,
  //                   label: 'Users & SubAdmins',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.group,
  //                   label: 'Groups',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.message,
  //                   label: 'Messages',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.file_copy_sharp,
  //                   label: 'Master List',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.list_alt_sharp,
  //                   label: 'Risk Assessment',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.list_alt_sharp,
  //                   label: 'Other Files',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.list_alt_sharp,
  //                   label: 'User Orientation',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.edit,
  //                   label: 'Edit Profile',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.swap_horiz_outlined,
  //                   label: 'Go To Feedback',
  //                 ),
  //                 SideNavigationBarItem(
  //                   icon: Icons.logout,
  //                   label: 'Logout',
  //                 ),
  //               ],
  //               onTap: (index) async {
  //                 switch (index) {
  //                   case 0:
  //                     await navigateTo(
  //                         routeName: '/admin/communication-dashboard');
  //                     setIndex();
  //                     break;
  //                   case 1:
  //                     await navigateTo(routeName: '/admin/pending-requests');
  //                     setIndex();
  //                     break;
  //                   case 2:
  //                     await navigateTo(routeName: '/admin/users');
  //                     setIndex();
  //                     break;
  //                   case 3:
  //                     await navigateTo(routeName: '/admin/subadmins');
  //                     setIndex();
  //                     break;
  //                   case 4:
  //                     await navigateTo(routeName: '/admin/users-and-subadmins');
  //                     setIndex();
  //                     break;
  //                   case 5:
  //                     await navigateTo(routeName: '/admin/groups');
  //                     setIndex();
  //                     break;
  //                   case 6:
  //                     await navigateTo(routeName: '/admin/messages');
  //                     setIndex();
  //                     break;
  //                   case 7:
  //                     await navigateTo(routeName: '/admin/master-list');
  //                     setIndex();
  //                     break;
  //                   case 8:
  //                     await navigateTo(routeName: '/admin/risk-assessment');
  //                     setIndex();
  //                     break;
  //                   case 9:
  //                     await navigateTo(routeName: '/admin/other-file');
  //                     setIndex();
  //                     break;
  //                   case 10:
  //                     await navigateTo(routeName: '/admin/user-orientation');
  //                     setIndex();
  //                     break;
  //                   case 11:
  //                     await navigateTo(routeName: '/admin/edit-profile');
  //                     setIndex();
  //                     break;
  //                   case 12:
  //                     await navigateTo(routeName: '/admin/feedback-dashboard');
  //                     setIndex();
  //                     break;
  //                   case 13:
  //                     if (!mounted) return;
  //
  //                     showDialog(
  //                       context: context,
  //                       builder: (BuildContext context) {
  //                         return AlertDialog(
  //                           title:
  //                               const Text("Are you sure you want to logout ?"),
  //                           actions: [
  //                             TextButton(
  //                               child: const Text("CANCEL"),
  //                               onPressed: () => Navigator.of(context).pop(),
  //                             ),
  //                             TextButton(
  //                               child: const Text("OK"),
  //                               onPressed: () async {
  //                                 await AuthService.logout();
  //
  //                                 if (mounted) {
  //                                   context
  //                                       .read<GlobalState>()
  //                                       .setUserResponse(null);
  //
  //                                   Navigator.pushReplacementNamed(
  //                                     context,
  //                                     '/',
  //                                   );
  //                                 }
  //                               },
  //                             ),
  //                           ],
  //                         );
  //                       },
  //                     );
  //                     break;
  //                   default:
  //                 }
  //               },
  //             )
  //           ],
  //         )
  //       : Container();
  // }

  @override
  Widget build(BuildContext context) {
    var user = context.read<GlobalState>().user;
    var isLoading = context.watch<GlobalState>().isLoading;
    bool ismobilw = MediaQuery.of(context).size.width < 600;
    setIndex();

    // if (!ismobilw) {
      return !isLoading
          ? Row(
        children: [
          SideNavigationBar(
            expandable: true,
            initiallyExpanded: true,
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
                label: 'Pending Requests',
              ),
              SideNavigationBarItem(
                icon: Icons.account_circle_rounded,
                label: 'Users',
              ),
              SideNavigationBarItem(
                icon: Icons.manage_accounts,
                label: 'SubAdmins',
              ),
              SideNavigationBarItem(
                icon: Icons.account_tree,
                label: 'Users & SubAdmins',
              ),
              SideNavigationBarItem(
                icon: Icons.group,
                label: 'Groups',
              ),
              SideNavigationBarItem(
                icon: Icons.message,
                label: 'Messages',
              ),
              SideNavigationBarItem(
                icon: Icons.file_copy_sharp,
                label: 'Master List',
              ),
              SideNavigationBarItem(
                icon: Icons.list_alt_sharp,
                label: 'Risk Assessment',
              ),
              SideNavigationBarItem(
                icon: Icons.list_alt_sharp,
                label: 'Other Files',
              ),
              SideNavigationBarItem(
                icon: Icons.list_alt_sharp,
                label: 'User Orientation',
              ),
              SideNavigationBarItem(
                icon: Icons.edit,
                label: 'Edit Profile',
              ),
              SideNavigationBarItem(
                icon: Icons.swap_horiz_outlined,
                label: 'Go To Feedback',
              ),
              SideNavigationBarItem(
                icon: Icons.logout,
                label: 'Logout',
              ),
            ],
            onTap: (index) async {
              switch (index) {
                case 0:
                  await navigateTo(
                      routeName: '/admin/communication-dashboard');
                  setIndex();
                  break;
                case 1:
                  await navigateTo(routeName: '/admin/pending-requests');
                  setIndex();
                  break;
                case 2:
                  await navigateTo(routeName: '/admin/users');
                  setIndex();
                  break;
                case 3:
                  await navigateTo(routeName: '/admin/subadmins');
                  setIndex();
                  break;
                case 4:
                  await navigateTo(routeName: '/admin/users-and-subadmins');
                  setIndex();
                  break;
                case 5:
                  await navigateTo(routeName: '/admin/groups');
                  setIndex();
                  break;
                case 6:
                  await navigateTo(routeName: '/admin/messages');
                  setIndex();
                  break;
                case 7:
                  await navigateTo(routeName: '/admin/master-list');
                  setIndex();
                  break;
                case 8:
                  await navigateTo(routeName: '/admin/risk-assessment');
                  setIndex();
                  break;
                case 9:
                  await navigateTo(routeName: '/admin/other-file');
                  setIndex();
                  break;
                case 10:
                  await navigateTo(routeName: '/admin/user-orientation');
                  setIndex();
                  break;
                case 11:
                  await navigateTo(routeName: '/admin/edit-profile');
                  setIndex();
                  break;
                case 12:
                  await navigateTo(routeName: '/admin/feedback-dashboard');
                  setIndex();
                  break;
                case 13:
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
          ),
        ],
      )
          : Container();
    // } else {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Goltens Admin Panel'),
    //     ),
    //     drawer: Drawer(
    //       child: ListView(
    //         padding: EdgeInsets.zero,
    //         children: [
    //           DrawerHeader(
    //             child: Material(
    //               borderRadius: BorderRadius.circular(60),
    //               elevation: 8,
    //               child: CircleAvatar(
    //                 child: user?.data.avatar.isNotEmpty == true
    //                     ? ClipRRect(
    //                   borderRadius: BorderRadius.circular(100.0),
    //                   child: Image.network(
    //                     '$apiUrl/$avatar/${user?.data.avatar}',
    //                     errorBuilder: (
    //                         context,
    //                         obj,
    //                         stacktrace,
    //                         ) {
    //                       return Container();
    //                     },
    //                   ),
    //                 )
    //                     : Text(user?.data.name[0] ?? '---'),
    //               ),
    //             ),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //             ),
    //           ),
    //           SideNavigationBar(
    //             expandable: true,
    //             initiallyExpanded: true,
    //             theme: SideNavigationBarTheme(
    //               backgroundColor: Colors.white,
    //               togglerTheme: SideNavigationBarTogglerTheme.standard(),
    //               dividerTheme: SideNavigationBarDividerTheme.standard(),
    //               itemTheme: SideNavigationBarItemTheme(
    //                 selectedBackgroundColor: Theme.of(context).primaryColor,
    //                 selectedItemColor: Colors.black,
    //               ),
    //             ),
    //             header: SideNavigationBarHeader(
    //               image: Material(
    //                 borderRadius: BorderRadius.circular(60),
    //                 elevation: 8,
    //                 child: CircleAvatar(
    //                   child: user?.data.avatar.isNotEmpty == true
    //                       ? ClipRRect(
    //                     borderRadius: BorderRadius.circular(100.0),
    //                     child: Image.network(
    //                       '$apiUrl/$avatar/${user?.data.avatar}',
    //                       errorBuilder: (
    //                           context,
    //                           obj,
    //                           stacktrace,
    //                           ) {
    //                         return Container();
    //                       },
    //                     ),
    //                   )
    //                       : Text(user?.data.name[0] ?? '---'),
    //                 ),
    //               ),
    //               title: Text(user?.data.name ?? ''),
    //               subtitle: Container(),
    //             ),
    //             footer: const SideNavigationBarFooter(
    //               label: Text(
    //                 'Goltens Admin Panel',
    //                 textAlign: TextAlign.center,
    //               ),
    //             ),
    //             selectedIndex: selectedIndex,
    //             items: const [
    //               SideNavigationBarItem(
    //                 icon: Icons.dashboard_sharp,
    //                 label: 'Dashboard',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.done_all,
    //                 label: 'Pending Requests',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.account_circle_rounded,
    //                 label: 'Users',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.manage_accounts,
    //                 label: 'SubAdmins',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.account_tree,
    //                 label: 'Users & SubAdmins',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.group,
    //                 label: 'Groups',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.message,
    //                 label: 'Messages',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.file_copy_sharp,
    //                 label: 'Master List',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.list_alt_sharp,
    //                 label: 'Risk Assessment',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.list_alt_sharp,
    //                 label: 'Other Files',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.list_alt_sharp,
    //                 label: 'User Orientation',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.edit,
    //                 label: 'Edit Profile',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.swap_horiz_outlined,
    //                 label: 'Go To Feedback',
    //               ),
    //               SideNavigationBarItem(
    //                 icon: Icons.logout,
    //                 label: 'Logout',
    //               ),
    //             ],
    //             onTap: (index) async {
    //               switch (index) {
    //                 case 0:
    //                   await navigateTo(
    //                       routeName: '/admin/communication-dashboard');
    //                   setIndex();
    //                   break;
    //                 case 1:
    //                   await navigateTo(routeName: '/admin/pending-requests');
    //                   setIndex();
    //                   break;
    //                 case 2:
    //                   await navigateTo(routeName: '/admin/users');
    //                   setIndex();
    //                   break;
    //                 case 3:
    //                   await navigateTo(routeName: '/admin/subadmins');
    //                   setIndex();
    //                   break;
    //                 case 4:
    //                   await navigateTo(routeName: '/admin/users-and-subadmins');
    //                   setIndex();
    //                   break;
    //                 case 5:
    //                   await navigateTo(routeName: '/admin/groups');
    //                   setIndex();
    //                   break;
    //                 case 6:
    //                   await navigateTo(routeName: '/admin/messages');
    //                   setIndex();
    //                   break;
    //                 case 7:
    //                   await navigateTo(routeName: '/admin/master-list');
    //                   setIndex();
    //                   break;
    //                 case 8:
    //                   await navigateTo(routeName: '/admin/risk-assessment');
    //                   setIndex();
    //                   break;
    //                 case 9:
    //                   await navigateTo(routeName: '/admin/other-file');
    //                   setIndex();
    //                   break;
    //                 case 10:
    //                   await navigateTo(routeName: '/admin/user-orientation');
    //                   setIndex();
    //                   break;
    //                 case 11:
    //                   await navigateTo(routeName: '/admin/edit-profile');
    //                   setIndex();
    //                   break;
    //                 case 12:
    //                   await navigateTo(routeName: '/admin/feedback-dashboard');
    //                   setIndex();
    //                   break;
    //                 case 13:
    //                   if (!mounted) return;
    //
    //                   showDialog(
    //                     context: context,
    //                     builder: (BuildContext context) {
    //                       return AlertDialog(
    //                         title:
    //                         const Text("Are you sure you want to logout ?"),
    //                         actions: [
    //                           TextButton(
    //                             child: const Text("CANCEL"),
    //                             onPressed: () => Navigator.of(context).pop(),
    //                           ),
    //                           TextButton(
    //                             child: const Text("OK"),
    //                             onPressed: () async {
    //                               await AuthService.logout();
    //
    //                               if (mounted) {
    //                                 context
    //                                     .read<GlobalState>()
    //                                     .setUserResponse(null);
    //
    //                                 Navigator.pushReplacementNamed(
    //                                   context,
    //                                   '/',
    //                                 );
    //                               }
    //                             },
    //                           ),
    //                         ],
    //                       );
    //                     },
    //                   );
    //                   break;
    //                 default:
    //               }
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }

}
