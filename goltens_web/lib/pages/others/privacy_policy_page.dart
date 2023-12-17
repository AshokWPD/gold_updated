// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We collect the following information about you:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                '* Name',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              const Text(
                '* Email Address',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              const Text(
                '* Phone Number',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              const Text(
                '* Access to Uploaded Files & Photos',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                'We do not share any of your information with third-party services.',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'All information is only used within the application to provide services.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Account Delete',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Delete your account by clicking "Delete Account" button in profile page.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact - Support',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  var anchorElement = html.AnchorElement(
                    href: 'mailto:Muthu.Manjunathan@goltens.com',
                  );

                  anchorElement.target = '_blank';
                  anchorElement.click();
                },
                child: const Text(
                  'Muthu.Manjunathan@goltens.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var anchorElement = html.AnchorElement(
                    href: 'tel:+6582983597',
                  );

                  anchorElement.target = '_blank';
                  anchorElement.click();
                },
                child: const Text(
                  '+6582983597',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var anchorElement = html.AnchorElement(
                    href: 'https://www.goltens.com/',
                  );

                  anchorElement.target = '_blank';
                  anchorElement.click();
                },
                child: const Text(
                  'https://www.goltens.com/',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(
                'Goltens Singapore',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
