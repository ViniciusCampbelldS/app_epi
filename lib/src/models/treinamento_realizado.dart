import 'treinamento.dart';

class TreinamentoRealizado {
  final int id;
  final Treinamento treinamento; // relação com a tabela treinamento
  final DateTime dataConclusao;

  TreinamentoRealizado({
    required this.id,
    required this.treinamento,
    required this.dataConclusao,
  });

  factory TreinamentoRealizado.fromJson(Map<String, dynamic> json) {
    return TreinamentoRealizado(
      id: json['id'],
      treinamento: Treinamento.fromJson(json['treinamento']),
      dataConclusao: DateTime.parse(json['dataConclusao']),
    );
  }

  // 04/11/2026
  String get dataFormatada {
    final dia = dataConclusao.day.toString().padLeft(2, '0');
    final mes = dataConclusao.month.toString().padLeft(2, '0');
    return '$dia/$mes/${dataConclusao.year}';
  }
}