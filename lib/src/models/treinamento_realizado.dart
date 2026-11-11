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

  // Data de conclusão + validade (nulo se o treinamento não vence)
  DateTime? get dataValidade {
    final meses = treinamento.validadeMeses;
    if (meses == null) return null;
    final total = dataConclusao.month - 1 + meses;
    final ano = dataConclusao.year + total ~/ 12;
    final mes = total % 12 + 1;
    final ultimoDia = DateTime(ano, mes + 1, 0).day;
    final dia = dataConclusao.day > ultimoDia ? ultimoDia : dataConclusao.day;
    return DateTime(ano, mes, dia);
  }

  bool get vencido {
    final validade = dataValidade;
    return validade != null && DateTime.now().isAfter(validade);
  }
}