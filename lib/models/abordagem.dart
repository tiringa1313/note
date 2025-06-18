class Abordagem {
  final String placa;
  final String motivo;
  final DateTime data;

  Abordagem({required this.placa, required this.motivo, required this.data});

  factory Abordagem.fromMap(Map<String, dynamic> map) {
    return Abordagem(
      placa: map['placa'] ?? '',
      motivo: map['motivo'] ?? '',
      data: DateTime.parse(map['data'] ??
          DateTime.now()
              .toString()), // Certifique-se de que a data é convertida corretamente
    );
  }
}
