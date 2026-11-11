import 'package:flutter/material.dart';

import '../models/funcionario.dart';
import '../models/treinamento_realizado.dart';
import '../services/treinamento_service.dart';

// Mostra os treinamentos já concluídos por um funcionário
class FuncionarioTreinamentosScreen extends StatelessWidget {
  final Funcionario funcionario;

  const FuncionarioTreinamentosScreen({super.key, required this.funcionario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(funcionario.nome),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<TreinamentoRealizado>>(
        future: TreinamentoService().buscarRealizados(funcionario.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final realizados = snapshot.data ?? [];
          if (realizados.isEmpty) {
            return const Center(
              child: Text('Nenhum treinamento concluído'),
            );
          }

          return ListView.builder(
            itemCount: realizados.length,
            itemBuilder: (context, index) {
              final r = realizados[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Icon(
                    r.vencido ? Icons.warning : Icons.check_circle,
                    color: r.vencido ? Colors.orange : Colors.green,
                  ),
                  title: Text(r.treinamento.titulo),
                  subtitle: Text(
                    'Concluído em ${r.dataFormatada}'
                    '${r.vencido ? '\nVencido – refazer' : ''}',
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
