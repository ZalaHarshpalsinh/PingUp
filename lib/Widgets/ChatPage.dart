import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Services/index.dart';
import 'package:pingup/models/index.dart';

class ChatPage extends StatefulWidget
{
  Chat chat;
  User chatter;
  ChatPage({super.key, required this.chat, required this.chatter});

  @override
  State<ChatPage> createState() => _TestChatPageState();
}

class _TestChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  final MainService mainService = getIt<MainService>();
  final FlutterSecureStorage _secureStorage = getIt<FlutterSecureStorage>();
  final WebSocketService webSocketService = getIt<WebSocketService>();
  final TextEditingController _controller = TextEditingController();

  String? currentUserId;
  bool isLoading = true;
  bool hasError = false;

  Future<void> _fetchCurrentUserId() async {
    try {
      setState(() {
        isLoading = true;
      });
      final userId = await _secureStorage.read(key: 'userId');
      setState(() {
        currentUserId = userId;
      });
    } catch (e) {
      setState(() {
        //print("Client error: ${e}");
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMessages() async {
    print("\n\n\nFetching messages\n\n\n");
    try {
      setState(() {
        isLoading = true;
      });

      final jwt = await _secureStorage.read(key: 'jwt');

      final response = await mainService.getMessages(jwt!, widget.chat.id);
      print(response);
      if (response['success'])
      {
        print(response['data']);
        List<dynamic> data = response['data'];
        setState(() {
          messages = data.map((json) => Message.fromJson(json)).toList();
          isLoading = false;
          hasError = false;
        });
      }
      else
      {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        print("Client error: ${e}");
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        print("send message called");
        final jwt = await _secureStorage.read(key: 'jwt');
        final response = await mainService.sendMessage(jwt!, widget.chat.id, _controller.text.toString());
        print(response);
        if (!response['success']) {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
        _controller.clear();
      }
      catch (e) {
        setState(() {
          print("Client error: ${e}");
          hasError = true;
          isLoading = false;
        });
      }
    }
  }

  void _setupWebSocket() {
    // Listen for 'Profile Update' event
    webSocketService.socket!.on('Message sent', (data)
    {
      print("Receivede message sent event in chat page");
      //_fetchMessages();
      String chatId = data['chatId'];
      Message newMessage = Message.fromJson(data['message']);
      webSocketService.socket!.emit("Message Received", <String, dynamic>{
        'messageId': newMessage.id,
        'userId': currentUserId
      });
      if (chatId == widget.chat.id)
      {
        if(mounted)
        {
          setState(() {
            widget.chat.lastMessage = newMessage;
            messages.add(newMessage);
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _fetchCurrentUserId();
    _setupWebSocket();
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
    print(messages);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatter.name),
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
                  message.message,
                  message.senderId==currentUserId!,
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
