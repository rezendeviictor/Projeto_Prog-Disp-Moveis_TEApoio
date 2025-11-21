import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pictograma_model.dart';

class ApiService {
  // Busca pictogramas na API do Arasaac (em português)
  Future<List<PictogramaModel>> buscarPictogramas(String termo) async {
    // Se o termo for vazio, não busca nada
    if (termo.isEmpty) return [];
    
    // Endpoint de busca "best match" em português
    final url = Uri.parse('https://api.arasaac.org/api/pictograms/pt/search/$termo');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = json.decode(response.body);
        
        // Converte a lista de JSON para lista de Objetos PictogramaModel
        return listaJson.map((json) => PictogramaModel.fromJson(json)).toList();
      } else {
        // Se a API não encontrar ou der outro código, retorna lista vazia
        return [];
      }
    } catch (e) {
      print("Erro API: $e");
      return [];
    }
  }
}