import 'dart:convert'; // Trabalha com JSON
import 'package:http/http.dart' as http; // Faz requisições HTTP

import '../models/funcionario.dart';
import 'api_config.dart';

class FuncionarioService {

  // Busca a lista de funcionários na API
  Future<List<Funcionario>> buscarFuncionarios() async {

    // Faz uma requisição GET para o endpoint /funcionarios
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/funcionarios'));

    // Verifica se a requisição foi bem-sucedida
    if (response.statusCode == 200) {

      // Converte o JSON recebido em uma lista Dart
      // (utf8.decode garante os acentos: Manutenção, Produção...)
      List<dynamic> lista =
          json.decode(utf8.decode(response.bodyBytes));

      // Transforma cada item da lista em um objeto Funcionario
      return lista
          .map((item) => Funcionario.fromJson(item))
          .toList();

    } else {

      // Lança uma exceção em caso de erro
      throw Exception('Erro ao carregar funcionários');

    }
  }
}
