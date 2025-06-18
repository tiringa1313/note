import 'package:uuid/uuid.dart'; // Importe o pacote uuid

class Boletim {
  final String id; // Altere o tipo de ID para String
  final DateTime data;
  final String tituloAtendimento;
  final String descricao;

  Boletim({
    required this.id,
    required this.data,
    required this.descricao,
    required this.tituloAtendimento,
  });

  // Método para converter um Boletim em um mapa (útil para armazenamento em banco de dados, por exemplo)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tituloAtendimento': tituloAtendimento,
      'data': data.toIso8601String(),
      'descricao': descricao,
    };
  }

  // Método para criar um Boletim a partir de um mapa
  factory Boletim.fromMap(Map<String, dynamic> map) {
    return Boletim(
      id: map['id'],
      tituloAtendimento: map['tituloAtendimento'],
      data: DateTime.parse(map['data']),
      descricao: map['descricao'],
    );
  }

  // Método estático para criar um Boletim com um ID único gerado automaticamente
  static Boletim create({
    required DateTime data,
    required String tituloAtendimento,
    required String descricao,
  }) {
    String id = Uuid().v4(); // Gera um UUID único
    return Boletim(
      id: id,
      data: data,
      tituloAtendimento: tituloAtendimento,
      descricao: descricao,
    );
  }
}
