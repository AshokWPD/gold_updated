import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:goltens_mobile/pages/updates/employee/conference.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class CreateMeetLink extends StatefulWidget {
  CreateMeetLink({Key? key}) : super(key: key);

  @override
  State<CreateMeetLink> createState() => _CreateMeetLinkState();
}

class _CreateMeetLinkState extends State<CreateMeetLink> {
  Color primaryColor = const Color(0xff80d6ff);
  late TextEditingController inviteLinkController;
  late String _meetingCode;

  void _shareInviteLink() {
    if (inviteLinkController.text.isNotEmpty) {
      // Use the Share.share method to share the invite link
      Share.share(inviteLinkController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invite link is empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0, 8);
    inviteLinkController = TextEditingController(text: _meetingCode);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLottieAnimation(),
              const SizedBox(height: 20),
              _buildInviteLinkTextField(),
              const SizedBox(height: 25),
              _buildShareInviteLinkButton(),
              const SizedBox(height: 25),
              _buildStartMeetingButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Meet Code',style: TextStyle(color: Colors.black),),
      backgroundColor: primaryColor,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  Widget _buildLottieAnimation() {
    return Lottie.asset(
      'assets/json/invite.json', // Replace with your animation file path
      fit: BoxFit.contain,
    );
  }

  TextFormField _buildInviteLinkTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Invite Link',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        suffixIcon: GestureDetector(
          onTap: () => _copyToClipboard(),
          child: const Icon(Icons.copy,color: Colors.black,),
        ),
      ),
      controller: inviteLinkController,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter the invite link';
        }
        return null;
      },
    );
  }

  void _copyToClipboard() {
    if (inviteLinkController.text.isNotEmpty) {
      Clipboard.setData(
        ClipboardData(text: inviteLinkController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invite link copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  ElevatedButton _buildShareInviteLinkButton() {
    return ElevatedButton(
      onPressed: () async {
        _shareInviteLink();
        // final selectedEmployee = await Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const EmployeeSelectionPage()),);
        //
        // if (selectedEmployee != null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Invite link shared with $selectedEmployee'),
        //       duration: const Duration(seconds: 2),
        //     ),
        //   );
        // }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share, color: Colors.black),
          SizedBox(width: 8),
          Text('Share Invite Link', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  ElevatedButton _buildStartMeetingButton() {
    return ElevatedButton(
      onPressed: () {
        // Get.to(Conference());
        // Implement the logic for joining with code
        Get.to((AgoraMeet(channelName: inviteLinkController.text.trim(),)));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_call, color: Colors.black),
          SizedBox(width: 8),
          Text('Start Meeting', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
