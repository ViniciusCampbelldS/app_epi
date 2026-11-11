import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/treinamento.dart';
import '../models/treinamento_realizado.dart';
import 'api_config.dart';

class TreinamentoService {

  // GET /treinamentos
  Future<List<Treinamento>> buscarTreinamentos() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/treinamentos'),
    );

    if (response.statusCode == 200) {
      List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
      return lista.map((item) => Treinamento.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar treinamentos');
  }

  // GET /treinamentos/realizados/funcionario/3
  Future<List<TreinamentoRealizado>> buscarRealizados(
      int funcionarioId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/treinamentos/realizados/funcionario/$funcionarioId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
      return lista
          .map((item) => TreinamentoRealizado.fromJson(item))
          .toList();
    }
    throw Exception('Erro ao carregar treinamentos concluídos');
  }

  // POST /treinamentos?adminId=1
  Future<void> cadastrar({
    required int adminId,
    required String titulo,
    String? descricao,
    String? nomeArquivo,
    int? validadeMeses,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/treinamentos?adminId=$adminId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'titulo': titulo,
        'descricao': descricao,
        'arquivoUrl':
            nomeArquivo == null ? null : '/documentos/$nomeArquivo',
        'validadeMeses': validadeMeses,
      }),
    );

    // 201 = criado; 403 = não é administrador; 400 = dados inválidos
    if (response.statusCode == 201) {
      return;
    }
    throw Exception(utf8.decode(response.bodyBytes));
  }

  // POST /treinamentos/2/concluir?funcionarioId=3
  Future<void> concluir(int treinamentoId, int funcionarioId) async {
    final response = await http.post(
      Uri.parse(
          '${ApiConfig.baseUrl}/treinamentos/$treinamentoId/concluir?funcionarioId=$funcionarioId'),
    );

    // 201 = registro de conclusão criado
    if (response.statusCode == 201) {
      return;
    }
    throw Exception(utf8.decode(response.bodyBytes));
  }
} // <-- Chave de fecho da classe adicionada aqui