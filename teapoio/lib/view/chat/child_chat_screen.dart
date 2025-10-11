import 'package:flutter/material.dart';

class ChildChatScreen extends StatefulWidget {
  const ChildChatScreen({super.key});

  @override
  State<ChildChatScreen> createState() => _ChildChatScreenState();
}

class _ChildChatScreenState extends State<ChildChatScreen> {
  final List<ChildChatMessage> _messages = [];
  final List<PecItem> _selectedPecs = [];

  // CATEGORIAS DE PECs
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

  void _sendMessage() {
    if (_selectedPecs.isEmpty) return;

    setState(() {
      _messages.add(ChildChatMessage(
        pecs: List.from(_selectedPecs),
        isSentByMe: true,
        timestamp: DateTime.now(),
      ));
      _selectedPecs.clear();
    });

    // Simular resposta do cuidador
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(ChildChatMessage(
          pecs: [PecItem('Entendido', 'assets/images/pec_entendido.png')],
          isSentByMe: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  void _clearMessage() {
    setState(() {
      _selectedPecs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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

          // MENSAGEM EM CONSTRUÇÃO
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
                          Container(
                            width: 70,
                            height: 70,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              pec.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, color: Colors.red);
                              },
                            ),
                          ),
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

          // LISTA DE MENSAGENS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // CATEGORIAS DE PECs
          SizedBox(
            height: 200,
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
        return _buildPecButton(pec, category.color);
      },
    );
  }

  Widget _buildPecButton(PecItem pec, Color categoryColor) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _addPecToMessage(pec),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  pec.imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        pec.text.substring(0, 2),
                        style: TextStyle(
                          fontSize: 12,
                          color: categoryColor,
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }

  Widget _buildMessageBubble(ChildChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isSentByMe)
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
              color: message.isSentByMe
                  ? const Color(0xFFB59DD9)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PECs DA MENSAGEM
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: message.pecs.map((pec) {
                    return Container(
                      width: 45,
                      height: 45,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: message.isSentByMe
                            ? Colors.white.withOpacity(0.25)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Image.asset(
                        pec.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                           return Tooltip(
                            message: pec.text,
                            child: const Icon(Icons.image_not_supported, size: 20),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: message.isSentByMe
                        ? Colors.white70
                        : Colors.grey[600],
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

class ChildChatMessage {
  final List<PecItem> pecs;
  final bool isSentByMe;
  final DateTime timestamp;

  ChildChatMessage({
    required this.pecs,
    required this.isSentByMe,
    required this.timestamp,
  });
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

  PecItem(this.text, this.imagePath);
}