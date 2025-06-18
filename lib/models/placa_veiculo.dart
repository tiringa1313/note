class PlacaVeiculo {
  final String placa;
  final String? marca;
  final String? modelo;
  final String? ano;

  final String? fotoPath;
  final String? fotoChassi; // Novo campo para foto do chassi
  final String? fotoVeiculo; // Foto do veículo
  final String? chassi; // Campo para armazenar o chassi
  final DateTime dataCadastro;

  PlacaVeiculo({
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.chassi,
    required this.fotoPath,
    required this.fotoChassi,
    required this.fotoVeiculo,
    required this.dataCadastro,
  });
  // Método para converter a instância em um Map (necessário para o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'chassi': chassi,
      'fotoPath': fotoPath,
      'fotoChassi': fotoChassi, // Nova propriedade
      'fotoVeiculo': fotoVeiculo, // Nova propriedade
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }

  // Método para converter um Map de volta em um objeto PlacaVeiculo
  factory PlacaVeiculo.fromMap(Map<String, dynamic> map) {
    return PlacaVeiculo(
      placa: map['placa'],
      marca: map['marca'],
      modelo: map['modelo'],
      ano: map['ano'],
      chassi: map['chassi'],
      fotoPath: map['fotoPath'],
      fotoChassi: map['fotoChassi'], // Nova propriedade
      fotoVeiculo: map['fotoVeiculo'], // Nova propriedade
      dataCadastro: DateTime.parse(map['dataCadastro']),
    );
  }
}
