import 'epi.dart';
package com.projeto.api_epi.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Emprestimo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "funcionario_id")
    private Funcionario funcionario;

    @ManyToOne(optional = false)
    @JoinColumn(name = "epi_id")
    private Epi epi;

    @Column(nullable = false)
    private LocalDate dataEmprestimo;

    private LocalDate dataDevolucao;

    @Column(nullable = false, length = 15)
    private String status;

    // NOVO na Aula 10 (4): motivo informado pelo funcionário no formulário
    @Column(length = 200)
    private String observacao;

	//Execício da aula 10 (4)
	class Emprestimo {
		final int id;
		final DateTime dataEmprestimo;
		final String status;
		final String observacao;
		final Epi epi;

		Emprestimo({
			required this.id,
			required this.dataEmprestimo,
			required this.status,
			required this.observacao,
			required this.epi,
		});

		factory Emprestimo.fromJson(Map<String, dynamic> json) {
			return Emprestimo(
				id: json['id'],
				dataEmprestimo: DateTime.parse(json['dataEmprestimo']),
				status: json['status'],
				observacao: json['observacao'] ?? '',
				epi: Epi.fromJson(json['epi']), // Converte o EPI aninhado
			);
		}

		// Opcional: Formatar a data para exibição (ex: 06/11/2026)
		String get dataFormatada {
			final dia = dataEmprestimo.day.toString().padLeft(2, '0');
			final mes = dataEmprestimo.month.toString().padLeft(2, '0');
			return '$dia/$mes/${dataEmprestimo.year}';
		}
	}
}