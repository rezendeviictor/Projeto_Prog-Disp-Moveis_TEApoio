import 'package:flutter/material.dart';
import 'package:teapoio/main.dart';
import 'package:teapoio/model/message_model.dart';
import 'package:teapoio/service/chat_service.dart';
import 'package:teapoio/service/api_service.dart';
import 'package:teapoio/model/pictograma_model.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // Adicionado para uso seguro se necessário

class ChildChatScreen extends StatefulWidget {
  // Se você precisava passar um ID, declare ele aqui:
  // final String childId;
  // const ChildChatScreen({super.key, required this.childId});
  
  const ChildChatScreen({super.key});

  @override
  State<ChildChatScreen> createState() => _ChildChatScreenState();
}

class _ChildChatScreenState extends State<ChildChatScreen> {
  // SERVIÇOS
  final ChatService _chatService = ChatService();
  final ApiService _apiService = ApiService();
  
  // ESTADO
  final List<PecItem> _selectedPecs = [];
  final TextEditingController _searchController = TextEditingController();
  List<PictogramaModel> _apiResults = [];
  bool _isSearchingApi = false;
  
  // Exemplo de como corrigir o erro do 'widget':
  // Declare a variável como 'late' (tardia)
  late String chatId; 

  @override
  void initState() {
    super.initState();
    // INICIALIZE AQUI qualquer variável que dependa de 'widget.'
    // Exemplo: chatId = widget.childId; 
    
    // Como no seu código original não havia childId explícito, deixei apenas a estrutura pronta.
  }

  // CATEGORIAS
  final List<PecCategory> _categories = [
    PecCategory(
      'Alimentação',
      Icons.restaurant,
      Colors.orange,
      [
        PecItem('Comer', 'assets/images/alimentacao/comer.png'),
        PecItem('Beber', 'assets/images/alimentacao/beber.png'),
        PecItem('Arroz', 'assets/images/alimentacao/comer/arroz.png'),
        PecItem('Chocolate', 'assets/images/alimentacao/comer/chocolate.png'),
        PecItem('Frango', 'assets/images/alimentacao/comer/frango.png'),
        PecItem('Salada', 'assets/images/alimentacao/comer/salada.png'),
        PecItem('Fome', 'assets/images/alimentacao/fome.png'),
        PecItem('Sem Fome', 'assets/images/alimentacao/sem_fome.png'),
      ],
    ),
    PecCategory(
      'Atividades',
      Icons.sports_soccer,
      Colors.green,
      [],
    ),
    PecCategory(
      'Emoções',
      Icons.emoji_emotions,
      Colors.blue,
      [],
    ),
    PecCategory(
      'Saúde',
      Icons.medical_services,
      Colors.red,
      [],
    ),
    PecCategory(
      'Internet',
      Icons.cloud_download,
      Colors.purple,
      [], 
    ),
  ];

  void _addPecToMessage(PecItem pec) {
    setState(() {
      _selectedPecs.add(pec);
    });
  }

  void _removePecFromMessage(int index) {
    setState(() {
      _selectedPecs.removeAt(index);
    });
  }

  void _sendMessage() async {
    if (_selectedPecs.isEmpty) return;

    String messageText = _selectedPecs.map((p) => p.text).join(" ");

    final authController = AppState.of(context).authController;
    final userEmail = authController.user?.email ?? 'Crianca';

    await _chatService.sendMessage(
      messageText,
      userEmail,
      false, 
    );

    setState(() {
      _selectedPecs.clear();
    });
  }

  void _clearMessage() {
    setState(() {
      _selectedPecs.clear();
    });
  }

  void _searchApi() async {
    String term = _searchController.text.trim();
    if (term.isEmpty) return;

    setState(() {
      _isSearchingApi = true;
    });

    final results = await _apiService.buscarPictogramas(term);

    setState(() {
      _apiResults = results;
      _isSearchingApi = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AppState.of(context).authController;
    final currentUserEmail = authController.user?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat - Versão Criança'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green[50],
            child: const Text(
              'Selecione PECs para construir sua mensagem',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),

          if (_selectedPecs.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                children: [
                  const Text(
                    'Sua mensagem:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: _selectedPecs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final pec = entry.value;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _buildPecCard(pec, size: 70),
                          Positioned(
                            top: -12,
                            right: -12,
                            child: GestureDetector(
                              onTap: () => _removePecFromMessage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        label: const Text('Enviar Mensagem'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB59DD9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _clearMessage,
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatService.getMessagesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: Text("Sem mensagens."));
                
                final messages = snapshot.data!;
                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true, 
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final msg = reversedMessages[index];
                    final isMe = msg.senderId == currentUserEmail;
                    
                    if (!isMe && !msg.isCaregiver) return const SizedBox();

                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),

          SizedBox(
            height: 250,
            child: DefaultTabController(
              length: _categories.length,
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[100],
                    child: TabBar(
                      isScrollable: true,
                      labelColor: const Color(0xFFB59DD9),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFFB59DD9),
                      tabs: _categories.map((category) {
                        return Tab(
                          icon: Icon(category.icon),
                          text: category.name,
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _categories.map((category) {
                        if (category.name == 'Internet') {
                          return _buildApiSearchTab();
                        }
                        return _buildCategoryGrid(category);
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

  Widget _buildApiSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Pesquisar na Internet (ex: Avião)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => _searchApi(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _searchApi,
              )
            ],
          ),
        ),
        Expanded(
          child: _isSearchingApi
            ? const Center(child: CircularProgressIndicator())
            : _apiResults.isEmpty
              ? const Center(child: Text("Digite para buscar novas figuras"))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _apiResults.length,
                  itemBuilder: (context, index) {
                    final apiPec = _apiResults[index];
                    final pecItem = PecItem(
                      apiPec.texto, 
                      apiPec.urlImagem, 
                      isNetworkImage: true 
                    );
                    return InkWell(
                      onTap: () => _addPecToMessage(pecItem),
                      child: _buildPecCard(pecItem, size: 50),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(PecCategory category) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: category.pecs.length,
      itemBuilder: (context, index) {
        final pec = category.pecs[index];
        return InkWell(
          onTap: () => _addPecToMessage(pec),
          child: _buildPecCard(pec, size: 50),
        );
      },
    );
  }

  Widget _buildPecCard(PecItem pec, {required double size}) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: pec.isNetworkImage
                  ? Image.network(pec.imagePath, fit: BoxFit.contain)
                  : Image.asset(
                      pec.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              pec.text,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isMe) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFB59DD9),
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFB59DD9) : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text.toUpperCase(),
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${message.timestamp.toDate().hour}:${message.timestamp.toDate().minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PecCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<PecItem> pecs;

  PecCategory(this.name, this.icon, this.color, this.pecs);
}

class PecItem {
  final String text;
  final String imagePath;
  final bool isNetworkImage;

  PecItem(this.text, this.imagePath, {this.isNetworkImage = false});
}