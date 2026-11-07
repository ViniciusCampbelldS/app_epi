import 'package:flutter/material.dart';

import '../models/epi.dart';
import '../models/usuario.dart';
import '../services/api_config.dart';
import '../services/epi_service.dart';
import 'epi_detalhe_screen.dart';

class EpiScreen extends StatelessWidget {
	final Usuario usuario; // Recebe o usuário logado
	
	const EpiScreen({
		super.key,
		required this.usuario // requer um usuário
		});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
			title: const Text('Lista de EPIs'),
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
			
			body: FutureBuilder<List<Epi>>(
			// Busca os dados da API
			future: EpiService().buscarEpis(),
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
				final epis = snapshot.data ?? [];

				return ListView.builder(
					itemCount: epis.length,
					itemBuilder: (context, index) {
					final epi = epis[index];
					final urlImagem = '${ApiConfig.baseUrl}${epi.imagemUrl}';

					// Exercício 3b: cor de destaque quando o CA está vencido
					final corTexto = epi.caVencido ? Colors.red : Colors.black87;

					return Card(
						elevation: 3,
						margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
						color: epi.caVencido ? Colors.red.shade50 : null,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(12),
							side: epi.caVencido
								? const BorderSide(color: Colors.red, width: 2)
								: BorderSide.none,
						),

						child: ListTile(
							// Aula 10 (4) ao tocar no EPI, abre a tela de detalhes
							onTap: () {
								Navigator.push(
									context, 
									MaterialPageRoute(
										builder: (_) => EpiDetalheScreen(
											epi: epi,
											usuario: usuario,
										),
									),
								);
							},
							
							leading: ClipRRect(
							borderRadius: BorderRadius.circular(8),

							child: Image.network(
								urlImagem,
								width: 55,
								height: 55,
								fit: BoxFit.cover,

								errorBuilder: (context, error, stackTrace) {
									return Container(
									width: 55,
									height: 55,
									color: Colors.blue.shade50,

									child: const Icon(
										Icons.health_and_safety,
										color: Colors.blue,
										size: 30,
									),
									);
								},
							),
							),

							title: Text(
							epi.nome,
							style: TextStyle(
								color: corTexto,
								fontWeight: FontWeight.bold,
							),
							),

							isThreeLine: true,

							subtitle: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(epi.categoria),

								// Exercício 3b: CA e validade em vermelho se vencido
								Text(
									epi.caVencido
										? 'CA: ${epi.ca} - VENCIDO em ${epi.validadeFormatada}'
										: 'CA: ${epi.ca} - válido até ${epi.validadeFormatada}',
									style: TextStyle(
									color: epi.caVencido ? Colors.red : null,
									fontWeight: epi.caVencido ? FontWeight.bold : null,
									),
								),

								// Exercício 3a: quantidade disponível
								Text(
									epi.quantidadeDisponivel > 0
										? 'Disponível: ${epi.quantidadeDisponivel} un.'
										: 'Sem estoque',
									style: TextStyle(
									color: epi.quantidadeDisponivel > 0
											? Colors.green.shade700
											: Colors.orange.shade800,
									fontWeight: FontWeight.w600,
									),
								),
							],
							),

							// Ícone de alerta à direita para o CA vencido
							trailing: epi.caVencido
								? const Tooltip(
									message: 'CA vencido',
									child: Icon(Icons.warning_amber_rounded,
											color: Colors.red),
									)
								: null,
						),
					);
					},
				);
			},
			),
		);
	}
}
