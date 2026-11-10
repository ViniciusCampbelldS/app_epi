class Treinamento {
  final int id;
  final String titulo;
  final String? descricao; // pode vir nulo
  final String? arquivoUrl; // pode vir nulo (treinamento sem material)

  Treinamento({
    required this.id,
    required this.titulo,
    this.descricao,
    this.arquivoUrl,
  });

  factory Treinamento.fromJson(Map<String, dynamic> json) {
    return Treinamento(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      arquivoUrl: json['arquivoUrl'],
    );
  }
}