import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// class Notifications {
//   String? title, body, userID;
//   Map<String, String>? extraData;
//   Timestamp? timestamp;
//   Notifications(
//       {this.timestamp, this.body, this.extraData, this.title, this.userID});

//   factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
//         timestamp: json["time stamp"],
//         title: json["title"],
//         body: json['body'],
//         extraData: json['extra data'] ?? {},
//         userID: json['userID'],
//       );
// }

class Notifications {
  String? title, body, userID;
  Map<String, dynamic>? extraData; // Use dynamic for flexibility
  Timestamp? timestamp;

  Notifications(
      {this.timestamp, this.body, this.extraData, this.title, this.userID});

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        timestamp: json["time stamp"],
        title: json["title"],
        body: json['body'],
        extraData: _parseExtraData(json['extra data']), // Use separate function
        userID: json['userID'],
      );

  // Function to handle parsing extraData
  static Map<String, dynamic> _parseExtraData(dynamic data) {
    if (data is String) {
      // Try parsing the string as JSON if it's a string
      try {
        return {"orderID": data, "receiver": "buyer"};
      } catch (e) {
        // Handle potential parsing error (optional)
        print("Error parsing extraData: $e");
        return {}; // Or return an empty map
      }
    } else if (data is Map<String, dynamic>) {
      // data is already a map, return it directly
      return data;
    } else {
      // Handle unexpected data type (optional)
      print("Unexpected type for extraData: ${data.runtimeType}");
      return {}; // Or return an empty map
    }
  }
}
