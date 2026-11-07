import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class EmprestimoService {

	// Envia a solicitação de empréstimo para a API
	Future<void> solicitar({
		required int funcionarioId,
		required int epiId,
		required String observacao,
	}) async {
		final response = await http.post(
			Uri.parse('${ApiConfig.baseUrl}/emprestimos'),
			headers: {
			'Content-Type': 'application/json',
			},
			// Mesmo formato da entidade Emprestimo do Java:
			// funcionário e EPI vão "dentro" do pedido, só com o id
			body: jsonEncode({
			'funcionario': {'id': funcionarioId},
			'epi': {'id': epiId},
			'observacao': observacao,
			}),
		);

		// 201 = Created: o empréstimo foi gravado
		if (response.statusCode == 201) {
			return;
		}

		// 400: a API explica o motivo (CA vencido, sem estoque...)
		throw Exception(utf8.decode(response.bodyBytes));
	}
}