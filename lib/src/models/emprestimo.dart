import 'epi.dart';

//Execício da aula 10 (4)
class Emprestimo {
	final int id;
	final DateTime dataEmprestimo;
	final String status;
	final String observacao;
	final Epi epi;

	Emprestimo({
		required this.id,
		required this.dataEmprestimo,
		required this.status,
		required this.observacao,
		required this.epi,
	});

	factory Emprestimo.fromJson(Map<String, dynamic> json) {
		return Emprestimo(
			id: json['id'],
			dataEmprestimo: DateTime.parse(json['dataEmprestimo']),
			status: json['status'],
			observacao: json['observacao'] ?? '',
			epi: Epi.fromJson(json['epi']), // Converte o EPI aninhado
		);
	}

	// Opcional: Formatar a data para exibição (ex: 06/11/2026)
	String get dataFormatada {
		final dia = dataEmprestimo.day.toString().padLeft(2, '0');
		final mes = dataEmprestimo.month.toString().padLeft(2, '0');
		return '$dia/$mes/${dataEmprestimo.year}';
	}
}