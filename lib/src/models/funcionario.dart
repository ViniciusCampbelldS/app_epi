// Model que representa um funcionário vindo da API (/funcionarios).
// Repare que NÃO existe o campo senha: a API não devolve a senha
// (@JsonProperty WRITE_ONLY no Java) e o app também não precisa dela.
class Funcionario {
	final int id;
	final String matricula;
	final String nome;
	final String setor;

	Funcionario({
		required this.id,
		required this.matricula,
		required this.nome,
		required this.setor,
	});

	// Construtor de fábrica que converte o JSON recebido da API
	// em um objeto Funcionario do Flutter.
	factory Funcionario.fromJson(Map<String, dynamic> json) {
		return Funcionario(
			id: json['id'],
			matricula: json['matricula'],
			nome: json['nome'],
			setor: json['setor'],
		);
	}
	}
