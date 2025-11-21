import 'package:flutter/material.dart';
import 'package:teapoio/main.dart';
import 'package:teapoio/model/message_model.dart';
import 'package:teapoio/service/chat_service.dart';
import 'package:teapoio/service/api_service.dart';
import 'package:teapoio/model/pictograma_model.dart';

class ChildChatScreen extends StatefulWidget {
  const ChildChatScreen({super.key});

  @override
  State<ChildChatScreen> createState() => _ChildChatScreenState();
}

class _ChildChatScreenState extends State<ChildChatScreen> {
  // SERVIÇOS (Isso é o que estava faltando)
  final ChatService _chatService = ChatService();
  final ApiService _apiService = ApiService();
  
  // ESTADO
  final List<PecItem> _selectedPecs = [];
  final TextEditingController _searchController = TextEditingController();
  List<PictogramaModel> _apiResults = [];
  bool _isSearchingApi = false;

  // CATEGORIAS (Mantive as suas, e adicionei a Internet no final)
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
      [
        PecItem('Brincar', 'assets/images/pec_brincar.png'),
        PecItem('Estudar', 'assets/images/pec_estudar.png'),
        PecItem('Desenhar', 'assets/images/pec_desenhar.png'),
        PecItem('Ler', 'assets/images/pec_ler.png'),
        PecItem('Dormir', 'assets/images/pec_dormir.png'),
        PecItem('Banho', 'assets/images/pec_banho.png'),
        PecItem('Escola', 'assets/images/pec_escola.png'),
        PecItem('Casa', 'assets/images/pec_casa.png'),
      ],
    ),
    PecCategory(
      'Emoções',
      Icons.emoji_emotions,
      Colors.blue,
      [
        PecItem('Feliz', 'assets/images/pec_feliz.png'),
        PecItem('Triste', 'assets/images/pec_triste.png'),
        PecItem('Bravo', 'assets/images/pec_bravo.png'),
        PecItem('Cansado', 'assets/images/pec_cansado.png'),
        PecItem('Com medo', 'assets/images/pec_medo.png'),
        PecItem('Com saudade', 'assets/images/pec_saudade.png'),
        PecItem('Amor', 'assets/images/pec_amor.png'),
        PecItem('Não gostei', 'assets/images/pec_nao_gostei.png'),
      ],
    ),
    PecCategory(
      'Saúde',
      Icons.medical_services,
      Colors.red,
      [
        PecItem('Dor de cabeça', 'assets/images/pec_dor_cabeca.png'),
        PecItem('Dor de barriga', 'assets/images/pec_dor_barriga.png'),
        PecItem('Febre', 'assets/images/pec_febre.png'),
        PecItem('Medicamento', 'assets/images/pec_medicamento.png'),
        PecItem('Médico', 'assets/images/pec_medico.png'),
        PecItem('Banheiro', 'assets/images/pec_banheiro.png'),
        PecItem('Machucado', 'assets/images/pec_machucado.png'),
        PecItem('Bem', 'assets/images/pec_bem.png'),
      ],
    ),
    // NOVA CATEGORIA PARA A API
    PecCategory(
      'Internet',
      Icons.cloud_download,
      Colors.purple,
      [], // Lista vazia, será preenchida pela busca
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

  // Enviar mensagem REAL para o Firebase
  void _sendMessage() async {
    if (_selectedPecs.isEmpty) return;

    // Transforma as PECs em texto para salvar no banco
    String messageText = _selectedPecs.map((p) => p.text).join(" ");

    final authController = AppState.of(context).authController;
    final userEmail = authController.loggedInUserEmail ?? 'Crianca';

    await _chatService.sendMessage(
      messageText,
      userEmail,
      false, // false = enviado pela criança
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

  // Função para buscar na API
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
    final currentUserEmail = authController.loggedInUserEmail;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat - Versão Criança'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ÁREA DE CONSTRUÇÃO DA FRASE
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

          // LISTA DE MENSAGENS (Firebase Stream)
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatService.getMessagesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: Text("Sem mensagens."));
                
                final messages = snapshot.data!;
                // Inverte a lista para mostrar as mais recentes no final da lista
                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true, // Começa de baixo para cima
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final msg = reversedMessages[index];
                    final isMe = msg.senderId == currentUserEmail;
                    
                    // Opcional: Filtrar mensagens irrelevantes
                    if (!isMe && !msg.isCaregiver) return const SizedBox();

                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),

          // TABS DE CATEGORIAS + BUSCA API
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
                        // Se for a categoria Internet, mostra a busca
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

  // Widgets Auxiliares

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
                    // Converte resultado da API para PecItem
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
                  // Formata hora simples
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

// CLASSES AUXILIARES ATUALIZADAS
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
  final bool isNetworkImage; // Novo campo essencial

  PecItem(this.text, this.imagePath, {this.isNetworkImage = false});
}