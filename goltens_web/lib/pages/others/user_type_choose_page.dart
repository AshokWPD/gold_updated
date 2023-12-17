import 'package:flutter/material.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:provider/provider.dart';

class UserTypeChoosePage extends StatefulWidget {
  const UserTypeChoosePage({Key? key});

  @override
  State<UserTypeChoosePage> createState() => _UserTypeChoosePageState();
}

class _UserTypeChoosePageState extends State<UserTypeChoosePage> {
  @override
  void initState() {
    super.initState();
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
                  'Choose User Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
                const SizedBox(height: 15),
                buildCard(
                  icon: Icons.account_circle,
                  label: 'User',
                  userType: UserType.user,
                ),
                const SizedBox(height: 20),
                buildCard(
                  icon: Icons.manage_accounts,
                  label: 'SubAdmin',
                  userType: UserType.userAndSubAdmin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({required IconData icon, required String label, required UserType userType}) {
    return Card(
      child: InkWell(
        onTap: () {
          final user = context.read<GlobalState>().user?.data;
          user?.type = userType;
          navigateTo(routeName: '/choose-app');
        },
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
