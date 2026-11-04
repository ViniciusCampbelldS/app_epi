import 'package:flutter/material.dart';

import '../models/funcionario.dart';
import '../services/funcionario_service.dart';

class FuncionarioScreen extends StatelessWidget {
  const FuncionarioScreen({super.key});

  // Exercício 2: devolve um ícone diferente para cada setor
  IconData iconePorSetor(String setor) {
    switch (setor) {
      case 'Manutenção':
        return Icons.build;
      case 'Produção':
        return Icons.factory;
      case 'Almoxarifado':
        return Icons.inventory;
      default:
        return Icons.person; // setor não previsto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Funcionários'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fechar',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Funcionario>>(
        // Busca os dados da API
        future: FuncionarioService().buscarFuncionarios(),
        builder: (context, snapshot) {
          // Exibe indicador enquanto aguarda os dados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Exibe erro caso ocorra
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          // Recebe a lista retornada pela API
          final funcionarios = snapshot.data ?? [];

          if (funcionarios.isEmpty) {
            return const Center(child: Text('Nenhum funcionário cadastrado'));
          }

          return ListView.builder(
            itemCount: funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = funcionarios[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      iconePorSetor(funcionario.setor),
                      color: Colors.blue,
                    ),
                  ),

                  title: Text(funcionario.nome),

                  // Exibe matrícula e setor (a senha NÃO é exibida)
                  subtitle: Text(
                    'Matrícula: ${funcionario.matricula}\n'
                    'Setor: ${funcionario.setor}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
