import 'package:flutter/material.dart';
import '../models/dashboard_funcionario.dart';
import '../models/usuario.dart';
import '../services/dashboard_service.dart';
import '../widgets/indicador_card.dart';
import 'meus_emprestimos_screen.dart';
import 'treinamentos_screen.dart';

class DashboardFuncionarioScreen extends StatefulWidget {
	final Usuario usuario;

	const DashboardFuncionarioScreen({super.key, required this.usuario});

	@override
	State<DashboardFuncionarioScreen> createState() => _DashboardFuncionarioScreenState();
}

class _DashboardFuncionarioScreenState extends State<DashboardFuncionarioScreen> {
	late Future<DashboardFuncionario> futuroDados;

	@override
	void initState() {
		super.initState();
		futuroDados = DashboardService().buscarFuncionario(widget.usuario.id);
	}

	Future<void> recarregar() async {
		setState(() {
			futuroDados = DashboardService().buscarFuncionario(widget.usuario.id);
		});
		try {
			await futuroDados;
		} catch (_) {}
	}

	void abrir(Widget tela) {
		Navigator.push(context, MaterialPageRoute(builder: (_) => tela))
				.then((_) => recarregar());
	}

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<DashboardFuncionario>(
			future: futuroDados,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Center(child: CircularProgressIndicator());
				}
				if (snapshot.hasError) {
					return Center(
						child: Text(
							snapshot.error.toString().replaceFirst('Exception: ', ''),
						),
					);
				}
				final d = snapshot.data!;
				return RefreshIndicator(
					onRefresh: recarregar,
					child: ListView(
						padding: const EdgeInsets.all(16),
						children: [
							Text(
								'Bem-vindo ${widget.usuario.nome}',
								style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
							),
							const SizedBox(height: 16),
							GridView.count(
								crossAxisCount: 2,
								crossAxisSpacing: 12,
								mainAxisSpacing: 12,
								childAspectRatio: 0.95,
								shrinkWrap: true,
								physics: const NeverScrollableScrollPhysics(),
								children: [
									IndicadorCard(
										titulo: 'Meus EPIs em uso',
										valor: d.episEmUso,
										icone: Icons.health_and_safety,
										cor: Colors.blue,
										onTap: () => abrir(MeusEmprestimosScreen(usuario: widget.usuario)),
									),
									IndicadorCard(
										titulo: 'Meus treinamentos pendentes',
										valor: d.treinamentosPendentes,
										icone: Icons.school,
										cor: Colors.orange,
										onTap: () => abrir(TreinamentosScreen(usuario: widget.usuario)),
									),
								],
							),
						],
					),
				);
			},
		);
	}
}
