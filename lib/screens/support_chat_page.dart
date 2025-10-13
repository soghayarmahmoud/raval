import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/l10n/app_localizations.dart';
import '../models/support_chat_model.dart';
import '../services/support_chat_service.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final SupportChatService _chatService = SupportChatService();
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  late Future<SupportTicket> _ticketFuture;
  SupportTicket? _currentTicket;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _ticketFuture = _chatService.getOrCreateTicket();
    _ticketFuture.then((ticket) {
      setState(() => _currentTicket = ticket);
    });
  }

  Future<void> _sendMessage() async {
    final loc = AppLocalizations.of(context)!;
    if (_messageController.text.trim().isEmpty || _currentTicket == null) {
      return;
    }

    setState(() => _isSending = true);
    try {
      await _chatService.sendMessage(
          _currentTicket!.id, _messageController.text.trim());
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorSendingMessage)),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _sendImage() async {
    final loc = AppLocalizations.of(context)!;
    if (_currentTicket == null) return;

    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isSending = true);
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('support_chat')
          .child(_currentTicket!.id)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();

      await _chatService.sendMessage(_currentTicket!.id, loc.sentAnImage,
          imageUrl: imageUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorSendingImage)),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.customerService),
        actions: [
          if (_currentTicket != null && !_currentTicket!.isResolved)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(loc.endConversation),
                    content: Text(loc.endConversationConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(loc.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(loc.end),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _chatService.closeTicket(_currentTicket!.id);
                }
              },
            ),
        ],
      ),
      body: FutureBuilder<SupportTicket>(
        future: _ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(loc.errorLoadingChat),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _ticketFuture = _chatService.getOrCreateTicket();
                      });
                    },
                    child: Text(loc.retry),
                  ),
                ],
              ),
            );
          }

          final ticket = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: StreamBuilder<List<ChatMessage>>(
                  stream: _chatService.getMessages(ticket.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data ?? [];

                    if (messages.isEmpty) {
                      return Center(
                        child: Text(loc.startConversationHint),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = !message.isAdmin;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (message.imageUrl != null)
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child:
                                              Image.network(message.imageUrl!),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        message.imageUrl!,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (message.message.isNotEmpty)
                                  Text(
                                    message.message,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (!ticket.isResolved)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: _isSending ? null : _sendImage,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: loc.writeYourMessage,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: _isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send),
                        onPressed: _isSending ? null : _sendMessage,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
