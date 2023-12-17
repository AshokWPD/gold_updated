import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_mobile/provider/global_state.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_mobile/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AdminAppChoosePage extends StatefulWidget {
  const AdminAppChoosePage({super.key});

  @override
  State<AdminAppChoosePage> createState() => _AdminAppChoosePageState();
}

class _AdminAppChoosePageState extends State<AdminAppChoosePage> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
  }

  Future<void> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      final PermissionStatus status = await Permission.notification.request();

      if (status.isGranted) {
        // Notification permissions granted
      } else if (status.isDenied) {
        // Permission Denied
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
  }

  Future<bool> showExitDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure you want to exit ?"),
              actions: [
                TextButton(
                  child: const Text("CANCEL"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<GlobalState>().user?.data;

    return WillPopScope(
      onWillPop: showExitDialog,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose Application'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'logout':
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Are you sure you want to logout ?",
                          ),
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
                                  await authNavigate(context);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                  case 'exit':
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                  const PopupMenuItem(
                    value: 'exit',
                    child: Text('Exit'),
                  ),
                ];
              },
            )
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(100.0),
                        child: CircleAvatar(
                          radius: 60.0,
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
                              : Text(
                                  user?.name[0] ?? '---',
                                  style: const TextStyle(
                                    fontSize: 60.0,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Logged in as ${user?.name}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 0.9,
              padding: const EdgeInsets.all(12.0),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 350),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-communication');
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message,
                                size: 48.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 14.0),
                              const Text(
                                'Communication',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 350),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-feedback');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.feedback,
                            size: 48.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 14.0),
                          const Text(
                            'Feedback',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 350),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin-meeting');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_call,
                            size: 48.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 14.0),
                          const Text(
                            'Toolbox Meeting',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
