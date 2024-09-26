import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pingup/Widgets/index.dart';
import 'package:pingup/models/index.dart';
import 'package:pingup/Services/index.dart';

class ChatCard extends StatefulWidget
{
  final Chat chat;
  const ChatCard({super.key, required this.chat});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String? currentUserId;
  User? chatter;
  final FlutterSecureStorage _secureStorage = getIt<FlutterSecureStorage>(); // Use secure storage
  final WebSocketService webSocketService = getIt<WebSocketService>();

  Future<void> getCurrentUserIdAndSetChatter() async {
    // Fetch currentUserId from secureStorage
    currentUserId = await _secureStorage.read(key: 'userId');

    // Find the chatter, which is the participant who is not the current user
    setState(() {
      chatter = widget.chat.participants.firstWhere(
              (participant) => participant.id != currentUserId
      );
    }); // Trigger a rebuild once the chatter is set
  }

  void _setupWebSocket() {
    // Listen for 'Profile Update' event
    webSocketService.socket!.on('Message sent', (data)
    {
      print("Message sent in chat${data['chatId']}");
      String chatId = data['chatId'];
      Message newMessage = Message.fromJson(data['message']);

      if (chatId == widget.chat.id)
      {
        if(mounted)
        {
          setState(() {
            widget.chat.lastMessage = newMessage;
            if(newMessage.senderId != currentUserId) {
              widget.chat.unseenCount += 1;
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    getCurrentUserIdAndSetChatter();
    _setupWebSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    if (chatter == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String lastMessageText = widget.chat.lastMessage != null
        ? widget.chat.lastMessage!.senderId == currentUserId
          ? "You: ${widget.chat.lastMessage!.message}"
          : widget.chat.lastMessage!.message
        : "No messages yet";

    // Unseen messages count badge
    Widget unseenCountBadge = widget.chat.unseenCount > 0
        ?
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.green, // Badge background color
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.chat.unseenCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
      :
      const SizedBox(); // Empty space if no unseen messages

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(chatter!.profilePhoto),
      ),
      title: Text(
        chatter!.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        lastMessageText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      trailing: unseenCountBadge, // Shows unseen count on the right
      onTap: () {
        //Navigate to chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(chat: widget.chat, chatter: chatter!), // Pass chatter info to the next page
          ),
        ).then((_)=>setState(() {
          widget.chat.unseenCount = 0;
        }));
      },
    );
  }
}
