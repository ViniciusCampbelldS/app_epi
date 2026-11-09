import 'package:flutter/material.dart';
import '../models/emprestimo.dart';
import '../models/usuario.dart';
import '../services/emprestimo_service.dart';

class MeusEmprestimosScreen extends StatefulWidget {
	final Usuario usuario; // Recebe o usuário logado para filtrar (Req e)

	const MeusEmprestimosScreen({super.key, required this.usuario});

	@override
	State<MeusEmprestimosScreen> createState() => _MeusEmprestimosScreenState();
} // class MeusEmprestimosScreen

class _MeusEmprestimosScreenState extends State<MeusEmprestimosScreen> {
	late Future<List<Emprestimo>> _futuroEmprestimos;

	@override
	void initState() {
		super.initState();
		// Busca os empréstimos usando o ID do usuário logado
		_futuroEmprestimos = EmprestimoService().listarPorFuncionario(widget.usuario.id);
	} // void initState()

	// Função para definir a cor do status (Requisito 3)
	Color _corStatus(String status) {
		switch (status.toUpperCase()) {
			case 'SOLICITADO':
				return Colors.orange;
			case 'EMPRESTADO':
				return Colors.green;
			case 'DEVOLVIDO':
				return Colors.grey;
			default:
				return Colors.blue;
		} // switch
	} // Color _corStatus

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Meus Empréstimos'),
				backgroundColor: Colors.blue,
				foregroundColor: Colors.white,
			), // appBar: AppBar
			body: FutureBuilder<List<Emprestimo>>(
				future: _futuroEmprestimos,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					} else if (snapshot.hasError) {
						return Center(child: Text('Erro: ${snapshot.error}'));
					} else if (!snapshot.hasData || snapshot.data!.isEmpty) {
						return const Center(child: Text('Nenhum empréstimo encontrado.'));
					}

					final emprestimos = snapshot.data!;

					return ListView.builder(
						itemCount: emprestimos.length,
						itemBuilder: (context, index) {
							final emp = emprestimos[index];
							return Card(
								margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
								child: ListTile(
									title: Text(
										emp.epi.nome, // Nome do EPI (Req d)
										style: const TextStyle(fontWeight: FontWeight.bold),
									), // title: Text
									subtitle: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											const SizedBox(height: 4),
											Text('Data: ${emp.dataFormatada}'), // Data da solicitação (Req d)
											Text('Motivo: ${emp.observacao}'),   // Motivo (Req d)
										], // children:
									), // subtitle: Column
									trailing: Container(
										padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
										decoration: BoxDecoration(
											color: _corStatus(emp.status), // Cor baseada no status (Req 3)
											borderRadius: BorderRadius.circular(6),
										),
										child: Text(
											emp.status,
											style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
										), // child: Text
									), // trailing: Container
								), // child: ListTile
							); // return Card(
						}, // itemBuilder: (context, index)
					); // return ListView.builder
				}, // builder: (context, snapshot)
			), // body: FutureBuilder<List<Emprestimo>>
		); // return Scaffold
	} // Widget build(BuildContext context)
} // class _MeusEmprestimosScreenState