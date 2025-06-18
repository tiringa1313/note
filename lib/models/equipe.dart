class Equipe {
  final int id;
  final String viatura;
  final String nomenclaturaVtr;

  Equipe({
    required this.id,
    required this.viatura,
    required this.nomenclaturaVtr,
  });

  // Método para converter um Boletim em um mapa (útil para armazenamento em banco de dados, por exemplo)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viatura': viatura,
      'nomenclaturaVtr': nomenclaturaVtr,
    };
  }

  // Método para criar uma Equipe a partir de um mapa
  factory Equipe.fromMap(Map<String, dynamic> map) {
    return Equipe(
      id: map['id'],
      viatura: map['viatura'],
      nomenclaturaVtr: map['nomenclaturaVtr'],
    );
  }
}
