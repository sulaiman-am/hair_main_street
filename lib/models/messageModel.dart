import 'dart:convert';

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

ChatMessages chatMessageFromJson(String str) =>
    ChatMessages.fromJson(json.decode(str));

String chatMessagesToJson(ChatMessages data) => json.encode(data.toJson());

class ChatMessages {
  String? idTo;
  String? idFrom;
  String? content;
  String? timestamp;

  ChatMessages({
    this.idTo,
    this.idFrom,
    this.content,
    this.timestamp,
  });

  factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
        idTo: json["idTo"],
        idFrom: json["idFrom"],
        content: json["content"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "idTo": idTo,
        "idFrom": idFrom,
        "content": content,
        "timestamp": timestamp,
      };
}

class Chat {
  String? chatID;
  List<String>? members;
  String? recentMessageText;
  String? recentMessageSentBy;
  String? recentMessageSentAt;
  bool? readBy;

  Chat(
      {this.chatID,
      this.members,
      this.readBy,
      this.recentMessageSentAt,
      this.recentMessageSentBy,
      this.recentMessageText});
}
