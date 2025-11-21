import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teapoio/main.dart';
import 'package:teapoio/model/pictograma_model.dart';
import 'package:teapoio/service/api_service.dart';

class AddPecScreen extends StatefulWidget {
  const AddPecScreen({super.key});

  @override
  State<AddPecScreen> createState() => _AddPecScreenState();
}

class _AddPecScreenState extends State<AddPecScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<PictogramaModel> _apiResults = [];
  bool _isLoading = false;
  String _selectedCategory = 'Geral'; // Categoria padrão

  // Lista de categorias disponíveis para organizar
  final List<String> _categories = [
    'Geral',
    'Alimentação',
    'Atividades',
    'Emoções',
    'Saúde',
    'Lugares',
    'Pessoas'
  ];

  void _searchApi() async {
    String term = _searchController.text.trim();
    if (term.isEmpty) return;

    setState(() => _isLoading = true);
    
    // RF007: Consumo de API
    final results = await _apiService.buscarPictogramas(term);

    setState(() {
      _apiResults = results;
      _isLoading = false;
    });
  }

  void _savePecToFirestore(PictogramaModel pec) async {
    final authController = AppState.of(context).authController;
    final user = authController.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não identificado')),
      );
      return;
    }

    // RF003: Inserção de Dados (Salva na subcoleção do usuário)
    try {
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .collection('minhas_pecs')
          .add({
        'texto': pec.texto,
        'imagemUrl': pec.urlImagem,
        'categoria': _selectedCategory,
        'data_criacao': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PEC "${pec.texto}" salva em $_selectedCategory!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  void _showCategoryDialog(PictogramaModel pec) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salvar PEC'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(pec.urlImagem, height: 100),
                const SizedBox(height: 10),
                const Text('Escolha a categoria:'),
                DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
              ],
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _savePecToFirestore(pec);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Nova PEC'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar na internet (ex: Maçã)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchApi(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchApi,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _apiResults.isEmpty
                    ? const Center(child: Text('Pesquise para encontrar imagens'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _apiResults.length,
                        itemBuilder: (context, index) {
                          final pec = _apiResults[index];
                          return InkWell(
                            onTap: () => _showCategoryDialog(pec),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      pec.urlImagem,
                                      loadingBuilder: (ctx, child, loading) {
                                        if (loading == null) return child;
                                        return const Center(child: Icon(Icons.image, color: Colors.grey));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      pec.texto,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}