class PictogramaModel {
  final int id;
  final String urlImagem;
  final String texto;

  PictogramaModel({
    required this.id,
    required this.urlImagem,
    required this.texto,
  });

  // Fábrica para converter o JSON da API em um objeto Dart
  factory PictogramaModel.fromJson(Map<String, dynamic> json) {
    int idPictograma = json['_id'];
    
    // Tenta pegar a primeira palavra-chave (keyword) retornada pela API
    // Se não tiver, usa um texto padrão "Figura"
    String keyword = 'Figura';
    if (json['keywords'] != null && (json['keywords'] as List).isNotEmpty) {
      keyword = json['keywords'][0]['keyword'];
    }

    return PictogramaModel(
      id: idPictograma,
      // Monta a URL oficial do ARASAAC usando o ID
      urlImagem: 'https://static.arasaac.org/pictograms/$idPictograma/${idPictograma}_300.png',
      texto: keyword,
    );
  }
}