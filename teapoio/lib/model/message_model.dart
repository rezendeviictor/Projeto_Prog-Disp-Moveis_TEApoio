import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String text;
  final String senderId; 
  final bool isCaregiver; 
  final Timestamp timestamp;

  MessageModel({
    this.id,
    required this.text,
    required this.senderId,
    required this.isCaregiver,
    required this.timestamp,
  });


  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      text: map['texto'] ?? '',
      senderId: map['senderId'] ?? '',
      isCaregiver: map['isCaregiver'] ?? false,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'texto': text,
      'senderId': senderId,
      'isCaregiver': isCaregiver,
      'timestamp': timestamp,
    };
  }
}