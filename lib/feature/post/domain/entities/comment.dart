import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timeStamp;

  Comment(
      {required this.id,
      required this.postId,
      required this.userId,
      required this.userName,
      required this.text,
      required this.timeStamp});
      
  // Convert comment -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'postId': postId,
      'text': text,
      'timeStamp': timeStamp
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json["id"],
        postId: json["postId"],
        userId: json['userId'],
        userName: json["userName"],
        text: json["text"],
        timeStamp: (json["timeStamp"] as Timestamp).toDate());
  }
}
