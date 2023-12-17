import 'package:flutter/material.dart';
import 'package:goltens_web/routes/routes.dart';

class AdminAppChoosePage extends StatefulWidget {
  const AdminAppChoosePage({super.key});

  @override
  State<AdminAppChoosePage> createState() => _AdminAppChoosePageState();
}

class _AdminAppChoosePageState extends State<AdminAppChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth - 32;

              return SizedBox(
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
                      Icons.message,
                      'Communication',
                      '/admin/communication-dashboard',
                    ),
                    const SizedBox(height: 20),
                    buildCard(
                      Icons.feedback,
                      'Feedback',
                      '/admin/feedback-dashboard',
                    ),
                    const SizedBox(height: 15),
                    buildCard(
                      Icons.video_call,
                      'Toolbox Meeting',
                      '/admin/meeting-dashboard',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCard(IconData icon, String title, String route) {
    return Card(
      child: InkWell(
        onTap: () {
          navigateTo(routeName: route);
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 14.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
