class PictogramaModel {
  final int id;
  final String urlImagem;
  final String texto;

  PictogramaModel({
    required this.id,
    required this.urlImagem,
    required this.texto,
  });


  factory PictogramaModel.fromJson(Map<String, dynamic> json) {
    int idPictograma = json['_id'];
    

    String keyword = 'Figura';
    if (json['keywords'] != null && (json['keywords'] as List).isNotEmpty) {
      keyword = json['keywords'][0]['keyword'];
    }

    return PictogramaModel(
      id: idPictograma,

      urlImagem: 'https://static.arasaac.org/pictograms/$idPictograma/${idPictograma}_300.png',
      texto: keyword,
    );
  }
}