import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/treinamento_service.dart';

// Tela exclusiva do ADMIN: cadastra um novo treinamento
class CadastrarTreinamentoScreen extends StatefulWidget {
  final Usuario usuario;

  const CadastrarTreinamentoScreen({super.key, required this.usuario});

  @override
  State<CadastrarTreinamentoScreen> createState() =>
      _CadastrarTreinamentoScreenState();
}

class _CadastrarTreinamentoScreenState
    extends State<CadastrarTreinamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _arquivoController = TextEditingController();
  final _validadeController = TextEditingController();
  bool salvando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _arquivoController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  String? _vazioParaNulo(String texto) {
    final t = texto.trim();
    return t.isEmpty ? null : t;
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => salvando = true);
    try {
      await TreinamentoService().cadastrar(
        adminId: widget.usuario.id,
        titulo: _tituloController.text.trim(),
        descricao: _vazioParaNulo(_descricaoController.text),
        nomeArquivo: _vazioParaNulo(_arquivoController.text),
        validadeMeses: int.tryParse(_validadeController.text.trim()),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treinamento cadastrado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Treinamento'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe o título'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arquivoController,
                decoration: const InputDecoration(
                  labelText: 'Nome do arquivo (ex: NR06.pdf)',
                  helperText: 'O arquivo deve estar na pasta documentos da API',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _validadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Validade em meses (opcional)',
                  helperText: 'Deixe vazio se o treinamento não vence',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v.trim());
                  return (n == null || n <= 0) ? 'Informe um número válido' : null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: salvando ? null : salvar,
                  icon: const Icon(Icons.save),
                  label: Text(salvando ? 'Salvando...' : 'Cadastrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
