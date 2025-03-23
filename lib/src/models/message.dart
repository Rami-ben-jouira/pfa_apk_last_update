import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String doctoruid;
  final String uid;
  final String senderName;
  final String topic;
  final String messageContent;
  final DateTime timestamp;

  Message({
    required this.doctoruid,
    required this.uid,
    required this.senderName,
    required this.topic,
    required this.messageContent,
    required this.timestamp,
  });

  // Convert Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'doctoruid': doctoruid,
      'uid': uid,
      'senderName': senderName,
      'topic': topic,
      'messageContent': messageContent,
      'timestamp': Timestamp.fromDate(
          timestamp), // Convert DateTime to Firestore Timestamp
    };
  }

  // Create a Message object from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      doctoruid: map['doctoruid'],
      uid: map['uid'],
      senderName: map['senderName'],
      topic: map['topic'],
      messageContent: map['messageContent'],
      timestamp: (map['timestamp'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
