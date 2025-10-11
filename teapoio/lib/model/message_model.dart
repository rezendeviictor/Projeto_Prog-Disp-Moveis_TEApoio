
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isPec;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isPec,
    required this.timestamp,
  });
}