import 'package:flutter/material.dart';
import 'package:pingup/Services/index.dart';
import '../global.dart';

class TestChatPage extends StatefulWidget
{
  final String personName;
  final String personId;
  final MainService mainService = TmpMainService();
  TestChatPage({super.key, required this.personId, required this.personName});

  @override
  State<TestChatPage> createState() => _TestChatPageState();
}



class _TestChatPageState extends State<TestChatPage> {
  List<Map<String, dynamic>> messages = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _fetchMessages() async {
    List<Map<String, dynamic>> fetchedMessages = await widget.mainService.getMessages(userId, widget.personId);
    setState((){
      messages = fetchedMessages;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await widget.mainService.sendMessage(userId, widget.personId, _controller.text);
      _fetchMessages();
      _controller.clear();
    }
  }

  Widget _buildMessageBubble(String text, bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.green[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - index - 1];
                return _buildMessageBubble(
                  message['message'],
                  message['sender']==userId,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
