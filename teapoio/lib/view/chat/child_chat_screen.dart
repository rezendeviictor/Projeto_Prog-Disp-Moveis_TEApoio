import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teapoio/main.dart';
import 'package:teapoio/model/message_model.dart';
import 'package:teapoio/service/chat_service.dart';
import 'package:teapoio/view/pec/add_pec_screen.dart'; // Import da nova tela

class ChildChatScreen extends StatefulWidget {
  const ChildChatScreen({super.key});

  @override
  State<ChildChatScreen> createState() => _ChildChatScreenState();
}

class _ChildChatScreenState extends State<ChildChatScreen> {
  final ChatService _chatService = ChatService();
  final List<PecItem> _selectedPecs = [];
  
  // Categorias fixas para Tabs (usaremos Stream para popular o conteúdo)
  final List<String> _categoryNames = [
    'Geral', 'Alimentação', 'Atividades', 'Emoções', 'Saúde', 'Lugares', 'Pessoas'
  ];

  void _addPecToMessage(PecItem pec) {
    setState(() => _selectedPecs.add(pec));
  }

  void _removePecFromMessage(int index) {
    setState(() => _selectedPecs.removeAt(index));
  }

  void _sendMessage() async {
    if (_selectedPecs.isEmpty) return;
    String messageText = _selectedPecs.map((p) => p.text).join(" ");
    final authController = AppState.of(context).authController;
    final userEmail = authController.user?.email ?? 'Crianca';

    await _chatService.sendMessage(messageText, userEmail, false);
    setState(() => _selectedPecs.clear());
  }

  void _clearMessage() {
    setState(() => _selectedPecs.clear());
  }

  void _navigateToAddPec() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPecScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = AppState.of(context).authController;
    final user = authController.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Voz'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 30),
            tooltip: 'Adicionar nova PEC',
            onPressed: _navigateToAddPec,
          )
        ],
      ),
      body: Column(
        children: [
          // 1. ÁREA DE CONSTRUÇÃO
          _buildMessageConstructionArea(),

          // 2. HISTÓRICO (Stream Mensagens)
          Expanded(flex: 2, child: _buildChatHistory(user?.email)),

          // 3. PECS DO USUÁRIO (Stream Firestore - RF005)
          SizedBox(
            height: 250,
            child: DefaultTabController(
              length: _categoryNames.length,
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[100],
                    child: TabBar(
                      isScrollable: true,
                      labelColor: const Color(0xFFB59DD9),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFFB59DD9),
                      tabs: _categoryNames.map((name) => Tab(text: name)).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _categoryNames.map((category) {
                        return _buildPecsStream(user?.uid, category);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // RF005: Recuperação de Dados em Tempo Real
  Widget _buildPecsStream(String? userId, String category) {
    if (userId == null) return const Center(child: Text("Erro de usuário"));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('minhas_pecs')
          .where('categoria', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Nenhuma PEC nesta categoria."),
                TextButton(
                  onPressed: _navigateToAddPec,
                  child: const Text("Adicionar PEC +"),
                )
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final pec = PecItem(
              data['texto'] ?? 'Sem nome',
              data['imagemUrl'] ?? '',
              isNetworkImage: true,
            );
            return InkWell(
              onTap: () => _addPecToMessage(pec),
              child: _buildPecCard(pec),
            );
          },
        );
      },
    );
  }

  // WIDGETS AUXILIARES (Design)
  Widget _buildMessageConstructionArea() {
    if (_selectedPecs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        color: Colors.green[50],
        child: const Text(
          'Selecione PECs abaixo para falar',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _selectedPecs.asMap().entries.map((entry) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildPecCard(entry.value, size: 60),
                  Positioned(
                    top: -8, right: -8,
                    child: GestureDetector(
                      onTap: () => _removePecFromMessage(entry.key),
                      child: const CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Icon(Icons.close, size: 14, color: Colors.white)),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            label: const Text('FALAR'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB59DD9), foregroundColor: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildChatHistory(String? currentUserEmail) {
    return StreamBuilder<List<MessageModel>>(
      stream: _chatService.getMessagesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: Text("Histórico vazio"));
        final messages = snapshot.data!.reversed.toList();
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMe = msg.senderId == currentUserEmail;
            if (!isMe && !msg.isCaregiver) return const SizedBox();
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFB59DD9) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(msg.text.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? Colors.white : Colors.black)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPecCard(PecItem pec, {double size = 50}) {
    return Card(
      elevation: 2,
      child: Container(
        width: size,
        height: size + 20,
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.network(
                pec.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (c,e,s) => const Icon(Icons.broken_image, size: 20),
              ),
            ),
            Text(pec.text, style: const TextStyle(fontSize: 9), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class PecItem {
  final String text;
  final String imagePath;
  final bool isNetworkImage;
  PecItem(this.text, this.imagePath, {this.isNetworkImage = false});
}