import 'package:note_gm/models/condutor.dart';

class BoletimDeAcidenteRascunho {
  // Dados do condutor principal
  String? nomeCondutor;
  String? cpfCondutor;
  String? cnhCondutor;
  String? categoriaCnh;

  // Dados do veículo
  String? placa;
  String? modelo;
  String? cor;
  String? ano;

  // Versão do envolvido
  String? versaoDoCondutor;
  String? sentidoDeslocamento;

  // 🛑 Novo campo: rua selecionada
  String? ruaSelecionada;

  // Outras informações
  String? observacoesGerais;
  String? versaoDoAgente;

  // Lista de envolvidos adicionais
  List<CondutorPlacaVeiculo>? outrosEnvolvidos;

  BoletimDeAcidenteRascunho({
    this.nomeCondutor,
    this.cpfCondutor,
    this.cnhCondutor,
    this.categoriaCnh,
    this.placa,
    this.modelo,
    this.cor,
    this.ano,
    this.versaoDoCondutor,
    this.sentidoDeslocamento,
    this.ruaSelecionada, // 🔥 adicionado no construtor
    this.observacoesGerais,
    this.versaoDoAgente,
    this.outrosEnvolvidos,
  });

  factory BoletimDeAcidenteRascunho.fromJson(Map<String, dynamic> json) {
    return BoletimDeAcidenteRascunho(
      nomeCondutor: json['nomeCondutor'],
      cpfCondutor: json['cpfCondutor'],
      cnhCondutor: json['cnhCondutor'],
      categoriaCnh: json['categoriaCnh'],
      placa: json['placa'],
      modelo: json['modelo'],
      cor: json['cor'],
      ano: json['ano'],
      versaoDoCondutor: json['versaoDoCondutor'],
      sentidoDeslocamento: json['sentidoDeslocamento'],
      ruaSelecionada: json['ruaSelecionada'], // 🔥 carregando do JSON
      observacoesGerais: json['observacoesGerais'],
      versaoDoAgente: json['versaoDoAgente'],
      outrosEnvolvidos: (json['outrosEnvolvidos'] as List<dynamic>?)
          ?.map((e) => CondutorPlacaVeiculo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeCondutor': nomeCondutor,
      'cpfCondutor': cpfCondutor,
      'cnhCondutor': cnhCondutor,
      'categoriaCnh': categoriaCnh,
      'placa': placa,
      'modelo': modelo,
      'cor': cor,
      'ano': ano,
      'versaoDoCondutor': versaoDoCondutor,
      'sentidoDeslocamento': sentidoDeslocamento,
      'ruaSelecionada': ruaSelecionada, // 🔥 salvando no JSON
      'observacoesGerais': observacoesGerais,
      'versaoDoAgente': versaoDoAgente,
      'outrosEnvolvidos':
          outrosEnvolvidos?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}
