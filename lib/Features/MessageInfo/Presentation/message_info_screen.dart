import 'package:cpscom_admin/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MessageInfoScreen extends StatefulWidget {
  final Map<String, dynamic> chatMap;

  const MessageInfoScreen({super.key, required this.chatMap});

  @override
  State<MessageInfoScreen> createState() => _MessageInfoScreenState();
}

class _MessageInfoScreenState extends State<MessageInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Message Info',
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Text(widget.chatMap['message']),
          ),
          // Expanded(child: ListView.builder(
          //     itemCount: widget.chatMap['members'].length,
          //     itemBuilder: (context, index) {
          //   return Text('');
          // }))
        ],
      ),
    );
  }
}
