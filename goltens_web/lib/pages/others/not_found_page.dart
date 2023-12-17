import 'package:flutter/material.dart';
import 'package:goltens_web/routes/routes.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '404: Page Not Found',
              style: TextStyle(fontSize: 32.0),
            ),
            const SizedBox(height: 10),
            const Text('The page you are accessing is not there'),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                navigateTo(routeName: '/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Go Back To Home'),
            )
          ],
        ),
      ),
    );
  }
}
