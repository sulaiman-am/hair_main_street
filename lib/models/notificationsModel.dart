import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? title, body, extraData, userID;
  Timestamp? timestamp;
  Notifications(
      {this.timestamp, this.body, this.extraData, this.title, this.userID});

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        timestamp: json["time stamp"],
        title: json["title"],
        body: json['body'],
        extraData: json['extra data'],
        userID: json['userID'],
      );
}
