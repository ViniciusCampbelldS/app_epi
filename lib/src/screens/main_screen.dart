import 'package:flutter/material.dart';

import 'epi_screen.dart';
import 'funcionario_screen.dart';
import '../models/usuario.dart'; // adicionado para importar a classe Usuário
import 'login_screen.dart'; // para sair

class MainScreen extends StatelessWidget {
	final Usuario usuario; // adicionado para armazenar o usuário logado
		
	const MainScreen({
		super.key,
		required this.usuario // adicionado para receber o usuário logado
		});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
			title: const Text('Empréstimos de EPIs'),
			backgroundColor: Colors.blue,
			foregroundColor: Colors.white,
			),

			drawer: Drawer(
			child: ListView(
				children: [
				UserAccountsDrawerHeader( // Adicionado para exibir informações do usuário logado
					accountName: Text(usuario.nome), // exibe o nome do usuário logado
					accountEmail: Text(usuario.perfil), //exibe a matrícula do usuário logado
					currentAccountPicture: CircleAvatar(
						backgroundColor: Colors.white,
						child: Text(
							usuario.nome[0], // exibe a primeira Letra do usuário Logado
							style: const TextStyle(fontSize: 40.0),
						),  // Text
					),  // CircleAvatar
				), // UserAccountsDrawerHeader
				// erased DrawerHeader
				
				
				ListTile(
				  leading: const Icon(Icons.home),
				  title: const Text('Início'),
				  onTap: () {
					 Navigator.pop(context);
				  },
				),

				ListTile(
				  leading: const Icon(Icons.health_and_safety),
				  title: const Text('EPIs'),
				  onTap: () {
					 Navigator.push(
						context,
						MaterialPageRoute(
						  builder: (_) => const EpiScreen(),
						),
					 );
				  },
				),

				// Exercício 1d: nova opção no menu lateral
				ListTile(
				  leading: const Icon(Icons.people),
				  title: const Text('Funcionários'),
				  onTap: () {
					 Navigator.push(
						context,
						MaterialPageRoute(
						  builder: (_) => const FuncionarioScreen(),
						),
						);
					},
				),
				ListTile(
					leading: const Icon(Icons.logout, color: Colors.red),
					title: const Text('Sair'),
					onTap: () {
					Navigator.pushAndRemoveUntil(
						context,
						MaterialPageRoute(builder: (_) => const LoginScreen()),
						(route) => false,
						);
					},
				),
			],
		),
	),

		body: Center(
			child: Text(
				'Bem-vindo ${usuario.nome}',
				style: TextStyle(fontSize: 18),
				), // Text
			), // Center
		); // Scaffold
	} // Widget build(BuildContext context)
} // class MainScreen