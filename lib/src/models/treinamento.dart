class Treinamento {
  final int id;
  final String titulo;
  final String? descricao; // pode vir nulo
  final String? documentosUrl; // pode vir nulo (treinamento sem material)
  final int? validadeMeses; // nulo = não vence

  Treinamento({
    required this.id,
    required this.titulo,
    this.descricao,
    this.documentosUrl,
    this.validadeMeses,
  });

  factory Treinamento.fromJson(Map<String, dynamic> json) {
    return Treinamento(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      documentosUrl: (json['arquivoUrl'] ?? json['documentosUrl'])
          ?.toString()
          .replaceFirst('/arquivos/', '/documentos/'),
      validadeMeses: json['validadeMeses'],
    );
  }
}
