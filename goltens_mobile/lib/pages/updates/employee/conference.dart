import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:goltens_mobile/pages/updates/sub_admin/CreateLink.dart';
import 'package:http/http.dart';

class AgoraMeet extends StatefulWidget {
  final String channelName;

  AgoraMeet({Key? key, required this.channelName}) : super(key: key);

  @override
  State<AgoraMeet> createState() => _AgoraMeetState();
}

class _AgoraMeetState extends State<AgoraMeet> {
  late final AgoraClient _client;
  bool _loading = true;
  String tempToken = "";

  @override
  void initState() {
    super.initState();
    initializeAgoraClient();
  }

  Future<void> initializeAgoraClient() async {
    await getToken();
    await _client.initialize();
  }

  Future<void> getToken() async {
    String link =
        "https://golt.meeting.goltens.a2hosted.com/access_token?channelName=${widget.channelName}";
    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    setState(() {
      tempToken = data["token"];
      print("$tempToken");
      _client = AgoraClient(agoraConnectionData: AgoraConnectionData(
        appId: "098ee45d7dee4df69de3e1ec9fc338e4",
        tempToken: tempToken,
        channelName: widget.channelName,
      ),
      );
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        ),
        body: SafeArea(
          child: _loading
              ? CircularProgressIndicator()
              : Stack(
            children: [
              AgoraVideoViewer(
                client: _client,
                layoutType: Layout.floating,
                enableHostControls: true,
              ),
              AgoraVideoButtons(
                client: _client,
                addScreenSharing: true,
                onDisconnect: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMeetLink(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
