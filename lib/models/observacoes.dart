class Observacao {
  int? id;

  String tituloObservacao;
  String descricao;
  String dataCadastro;

  Observacao({
    this.id,
    required this.tituloObservacao,
    required this.descricao,
    required this.dataCadastro,
  });

  // Convertendo para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tituloObservacao': tituloObservacao,
      'descricao': descricao,
      'dataCadastro': dataCadastro,
    };
  }

  // Convertendo de Map para objeto Observacao
  factory Observacao.fromMap(Map<String, dynamic> map) {
    return Observacao(
      id: map['id'],
      tituloObservacao: map['tituloObservacao'],
      descricao: map['descricao'],
      dataCadastro: map['dataCadastro'],
    );
  }
}
