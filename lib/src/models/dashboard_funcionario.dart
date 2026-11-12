class DashboardFuncionario {
	final int episEmUso;
	final int treinamentosPendentes;

	DashboardFuncionario({
		required this.episEmUso,
		required this.treinamentosPendentes,
	});

	// As chaves são as mesmas do Map montado em DashboardService.indicadoresFuncionario (Java)
	factory DashboardFuncionario.fromJson(Map<String, dynamic> json) {
		return DashboardFuncionario(
			episEmUso: json['episEmUso'],
			treinamentosPendentes: json['treinamentosPendentes'],
		);
	}
}
