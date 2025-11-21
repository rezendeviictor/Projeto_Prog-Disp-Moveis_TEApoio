import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String text;
  final String senderId; // ID de quem enviou (Email ou UID)
  final bool isCaregiver; // Para saber se foi o Cuidador ou a Criança
  final Timestamp timestamp;

  MessageModel({
    this.id,
    required this.text,
    required this.senderId,
    required this.isCaregiver,
    required this.timestamp,
  });

  // Converte do Firestore para o Objeto Dart
  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      id: docId,
      text: map['texto'] ?? '',
      senderId: map['senderId'] ?? '',
      isCaregiver: map['isCaregiver'] ?? false,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  // Converte do Objeto Dart para o Firestore
  Map<String, dynamic> toMap() {
    return {
      'texto': text,
      'senderId': senderId,
      'isCaregiver': isCaregiver,
      'timestamp': timestamp,
    };
  }
}