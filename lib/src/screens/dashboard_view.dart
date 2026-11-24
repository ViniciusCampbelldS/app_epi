import 'package:app_epi/src/models/usuario.dart';
import 'package:flutter/material.dart';

import 'cadastrar_treinamento_screen.dart';
import 'emprestimos_screen.dart';
import 'epi_screen.dart';
import 'funcionario_screen.dart';
import 'treinamento_screen.dart';

class DashboardView extends StatefulWidget {
  final Usuario usuario;

  const DashboardView({
    super.key,
    required this.usuario,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isLoading = true;

  int totalEpis = 0;
  int meusEmprestimosAtivos = 0;
  int treinamentosDisponiveis = 0;
  int totalFuncionarios = 0;

  bool get isAdmin => widget.usuario.perfil.toUpperCase() == 'ADMIN';

  @override
  void initState() {
    super.initState();
    carregarIndicadores();
  }

  Future<void> carregarIndicadores() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      setState(() {
        totalEpis = 45;
        meusEmprestimosAtivos = 3;
        treinamentosDisponiveis = 8;
        totalFuncionarios = 24;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do painel: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String mensagemPermissao = isAdmin
        ? 'Você possui permissões para aprovar empréstimos e registrar devoluções.'
        : 'Você pode consultar EPIs e solicitar empréstimos.';

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: carregarIndicadores,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderBoasVindas(mensagemPermissao),
            const SizedBox(height: 20),
            const Text(
              'Resumo Geral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildGridIndicadores(),
            const SizedBox(height: 24),
            const Text(
              'Acesso Rápido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildAcoesRapidas(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderBoasVindas(String mensagemPermissao) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bem-vindo, ${widget.usuario.nome}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Chip(
                label: Text(
                  widget.usuario.perfil.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: isAdmin ? Colors.indigo : Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            mensagemPermissao,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget buildGridIndicadores() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.35,
      children: [
        buildCardKpi(
          titulo: 'EPIs Disponíveis',
          valor: totalEpis.toString(),
          icone: Icons.health_and_safety,
          cor: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpiScreen(usuario: widget.usuario),
            ),
          ),
        ),
        buildCardKpi(
          titulo: isAdmin ? 'Empréstimos' : 'Meus Empréstimos',
          valor: meusEmprestimosAtivos.toString(),
          icone: Icons.assignment,
          cor: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeusEmprestimosScreen(usuario: widget.usuario),
            ),
          ),
        ),
        buildCardKpi(
          titulo: 'Treinamentos',
          valor: treinamentosDisponiveis.toString(),
          icone: Icons.school,
          cor: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreinamentosScreen(usuario: widget.usuario),
            ),
          ),
        ),
        buildCardKpi(
          titulo: 'Funcionários',
          valor: totalFuncionarios.toString(),
          icone: Icons.people,
          cor: Colors.purple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FuncionarioScreen(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCardKpi({
    required String titulo,
    required String valor,
    required IconData icone,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icone, color: cor, size: 28),
                  Text(
                    valor,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: cor,
                    ),
                  ),
                ],
              ),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAcoesRapidas(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.health_and_safety, color: Colors.white),
            ),
            title: const Text('Consultar Catálogo de EPIs'),
            subtitle: const Text('Verificar equipamentos e solicitar empréstimo'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EpiScreen(usuario: widget.usuario),
              ),
            ),
          ),
          if (isAdmin) ...[
            const Divider(height: 1),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.add_task, color: Colors.white),
              ),
              title: const Text('Cadastrar Novo Treinamento'),
              subtitle: const Text('Acesso exclusivo de administrador'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CadastrarTreinamentoScreen(usuario: widget.usuario),
                ),
              ),
            ),
          ],
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.assignment, color: Colors.white),
            ),
            title: const Text('Gerenciar Empréstimos'),
            subtitle: const Text('Acompanhar status e devoluções'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeusEmprestimosScreen(usuario: widget.usuario),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
