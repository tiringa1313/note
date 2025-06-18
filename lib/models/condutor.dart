class CondutorPlacaVeiculo {
  String placa;
  String condutor;
  String cnh;
  String cpf;
  String observacao;
  String? fotoPath;
  DateTime dataCadastro;

  CondutorPlacaVeiculo({
    required this.placa,
    required this.condutor,
    required this.cnh,
    required this.cpf,
    required this.observacao,
    this.fotoPath,
    required this.dataCadastro,
  });

  factory CondutorPlacaVeiculo.fromJson(Map<String, dynamic> json) {
    return CondutorPlacaVeiculo(
      placa: json['placa'],
      condutor: json['condutor'],
      cnh: json['cnh'],
      cpf: json['cpf'],
      observacao: json['observacao'],
      fotoPath: json['fotoPath'],
      dataCadastro: DateTime.parse(json['dataCadastro']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa': placa,
      'condutor': condutor,
      'cnh': cnh,
      'cpf': cpf,
      'observacao': observacao,
      'fotoPath': fotoPath,
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }
}
