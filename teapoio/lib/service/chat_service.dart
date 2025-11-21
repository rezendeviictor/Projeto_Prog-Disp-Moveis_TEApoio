import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _messagesRef => _firestore.collection('mensagens');

  Future<void> sendMessage(String text, String userId, bool isCaregiver) async {
    try {
      final message = MessageModel(
        text: text,
        senderId: userId,
        isCaregiver: isCaregiver,
        timestamp: Timestamp.now(),
      );

      await _messagesRef.add(message.toMap());
    } catch (e) {
      print("Erro ao enviar mensagem: $e");
      rethrow;
    }
  }

  Stream<List<MessageModel>> getMessagesStream() {
    return _messagesRef
        .orderBy('timestamp', descending: false) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}