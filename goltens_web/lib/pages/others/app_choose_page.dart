import 'package:flutter/material.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/routes/routes.dart';

class AppChoosePage extends StatefulWidget {
  const AppChoosePage({Key? key});

  @override
  State<AppChoosePage> createState() => _AppChoosePageState();
}

class _AppChoosePageState extends State<AppChoosePage> {
  bool isLoading = true;
  bool isUserAndSubAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final userResponse = await AuthService.getMe();

      setState(() {
        isLoading = false;
        isUserAndSubAdmin = userResponse.data.type == UserType.userAndSubAdmin;
      });
    } catch (e) {
      // Handle the error
    }
  }

  Future<bool> showExitDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want to exit?"),
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
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double cardWidth = isMobile ? 300.0 : 500.0;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: cardWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Choose Your App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
                const SizedBox(height: 15),
                buildCard(
                  icon: Icons.message,
                  label: 'Communication',
                  onTap: () {
                    navigateTo(routeName: '/home');
                  },
                ),
                const SizedBox(height: 20),
                buildCard(
                  icon: Icons.feedback,
                  label: 'Feedback',
                  onTap: () {
                    navigateTo(routeName: '/feedback');
                  },
                ),
                const SizedBox(height: 15),
                buildCard(
                  icon: Icons.video_call,
                  label: 'Toolbox Meeting',
                  onTap: () {
                    navigateTo(routeName: '/admin/meeting-dashboard');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 14.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
