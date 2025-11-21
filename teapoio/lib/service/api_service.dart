import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pictograma_model.dart';

class ApiService {

  Future<List<PictogramaModel>> buscarPictogramas(String termo) async {

    if (termo.isEmpty) return [];
    

    final url = Uri.parse('https://api.arasaac.org/api/pictograms/pt/search/$termo');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = json.decode(response.body);
        
        return listaJson.map((json) => PictogramaModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erro API: $e");
      return [];
    }
  }
}