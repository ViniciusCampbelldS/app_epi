import 'package:flutter/material.dart';
import '../models/dashboard.dart';
import '../models/usuario.dart';
import '../services/dashboard_service.dart';
import '../widgets/indicador_card.dart';
import 'epi_screen.dart';
import 'funcionario_screen.dart';
import 'meus_emprestimos_screen.dart';

class DashboardScreen extends StatefulWidget {
	final Usuario usuario;

	const DashboardScreen({super.key, required this.usuario});

	@override
	State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
	late Future<Dashboard> futuroDados;
	DateTime atualizadoEm = DateTime.now();

	@override
	void initState() {
		super.initState();
		futuroDados = DashboardService().buscar(widget.usuario.id);
	}

	Future<void> recarregar() async {
		setState(() {
			futuroDados = DashboardService().buscar(widget.usuario.id);
			atualizadoEm = DateTime.now();
		});
		try {
			await futuroDados;
		} catch (_) {}
	}

	void abrir(Widget tela) {
		Navigator.push(context, MaterialPageRoute(builder: (_) => tela))
				.then((_) => recarregar());
	}

	String doisDigitos(int n) => n.toString().padLeft(2, '0');

	@override
	Widget build(BuildContext context) {
		final largura = MediaQuery.of(context).size.width;
		final colunas = largura >= 700 ? 3 : (largura >= 400 ? 2 : 1);
		final hoje = DateTime.now();

		return FutureBuilder<Dashboard>(
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
							const Text(
								'Painel de Segurança do Trabalho',
								style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
							),
							Padding(
								padding: const EdgeInsets.only(top: 4, bottom: 16),
								child: Text(
									'Olá, ${widget.usuario.nome} · ${doisDigitos(hoje.day)}/${doisDigitos(hoje.month)}/${hoje.year}',
									style: TextStyle(color: Colors.grey.shade600),
								),
							),
							if (d.caVencidos > 0)
								Container(
									margin: const EdgeInsets.only(bottom: 16),
									padding: const EdgeInsets.all(12),
									decoration: BoxDecoration(
										color: Colors.red.shade50,
										border: Border.all(color: Colors.red.shade200),
										borderRadius: BorderRadius.circular(12),
									),
									child: Row(
										children: [
											Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
											const SizedBox(width: 8),
											Expanded(
												child: Text(
													'${d.caVencidos} EPI(s) com CA vencido. Retire de uso e providencie a substituição.',
													style: TextStyle(color: Colors.red.shade800),
												),
											),
										],
									),
								),
							GridView(
								gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
									crossAxisCount: colunas,
									crossAxisSpacing: 12,
									mainAxisSpacing: 12,
									mainAxisExtent: 200,
								),
								shrinkWrap: true,
								physics: const NeverScrollableScrollPhysics(),
								children: [
									IndicadorCard(
										titulo: 'EPIs cadastrados',
									imagem: 'epis_cadastrados.png',
										valor: d.episCadastrados,
										icone: Icons.inventory_2,
										cor: Colors.indigo,
										onTap: () => abrir(EpiScreen(usuario: widget.usuario)),
									),
									IndicadorCard(
										titulo: 'EPIs emprestados',
									imagem: 'epis_emprestados.png',
										valor: d.episEmprestados,
										icone: Icons.outbox,
										cor: Colors.blue,
										onTap: () => abrir(MeusEmprestimosScreen(usuario: widget.usuario)),
									),
									IndicadorCard(
										titulo: 'EPIs devolvidos',
									imagem: 'epis_devolvidos.png',
										valor: d.episDevolvidos,
										icone: Icons.assignment_return,
										cor: Colors.green,
									),
									IndicadorCard(
										titulo: 'CA vencidos',
									imagem: 'ca_vencidos.png',
										valor: d.caVencidos,
										icone: Icons.gpp_bad,
										cor: Colors.red,
										onTap: () => abrir(EpiScreen(usuario: widget.usuario)),
									),
									IndicadorCard(
										titulo: 'Solicitações pendentes',
									imagem: 'solicitacoes_pendentes.png',
										valor: d.solicitacoesPendentes,
										icone: Icons.pending_actions,
										cor: Colors.amber,
										onTap: () => abrir(MeusEmprestimosScreen(usuario: widget.usuario)),
									),
									IndicadorCard(
										titulo: 'Treinamentos pendentes',
									imagem: 'treinamentos_pendentes.jpg',
										valor: d.treinamentosPendentes,
										icone: Icons.school,
										cor: Colors.orange,
									),
									IndicadorCard(
										titulo: 'Funcionários cadastrados',
									imagem: 'funcionarios_cadastrados.png',
										valor: d.funcionariosCadastrados,
										icone: Icons.people,
										cor: Colors.teal,
										onTap: () => abrir(const FuncionarioScreen()),
									),
									IndicadorCard(
										titulo: 'Estoque baixo',
									imagem: 'estoque_baixo.jpg',
										valor: d.estoqueBaixo,
										icone: Icons.production_quantity_limits,
										cor: Colors.deepOrange,
										onTap: () => abrir(EpiScreen(usuario: widget.usuario)),
									),
								],
							),
							const SizedBox(height: 16),
							Row(
								children: [
									Text(
										'Atualizado às ${doisDigitos(atualizadoEm.hour)}:${doisDigitos(atualizadoEm.minute)}',
										style: TextStyle(color: Colors.grey.shade600),
									),
									const Spacer(),
									TextButton.icon(
										onPressed: recarregar,
										icon: const Icon(Icons.refresh),
										label: const Text('Atualizar'),
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
