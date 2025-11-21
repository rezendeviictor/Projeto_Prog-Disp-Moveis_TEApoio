import 'package:flutter/material.dart';
import '../model/pictograma_model.dart';
import '../service/api_service.dart';

class BuscaPecScreen extends StatefulWidget {
  const BuscaPecScreen({super.key});

  @override
  State<BuscaPecScreen> createState() => _BuscaPecScreenState();
}

class _BuscaPecScreenState extends State<BuscaPecScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  
  // Future para o FutureBuilder
  Future<List<PictogramaModel>>? _futurePictogramas;

  void _realizarBusca() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _futurePictogramas = _apiService.buscarPictogramas(_searchController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Nova PEC (API)"),
        backgroundColor: const Color(0xFFB59DD9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de Busca
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Digite o nome (ex: comer, escola)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _realizarBusca,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Exibição dos Resultados com FutureBuilder (Padrão do Professor)
            Expanded(
              child: FutureBuilder<List<PictogramaModel>>(
                future: _futurePictogramas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Erro ao buscar dados."));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhum pictograma encontrado."));
                  }

                  // Lista de Imagens
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final pec = snapshot.data![index];
                      return Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                pec.urlImagem,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                pec.texto,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}