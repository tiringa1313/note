class AgenteInfoRascunho {
  final String? rua;
  final String? cruzamento;
  final String? numero;
  final String? bairro;
  final String? referencia;
  final String? desfechoAtendimento;
  final String? tipoSinistro;
  final List<String>? sinalizacoesSelecionadas;
  final String? viatura; // ✅ NOVO
  final String? equipe; // ✅ NOVO

  AgenteInfoRascunho({
    this.rua,
    this.cruzamento,
    this.numero,
    this.bairro,
    this.referencia,
    this.desfechoAtendimento,
    this.tipoSinistro,
    this.sinalizacoesSelecionadas,
    this.viatura, // ✅ NOVO
    this.equipe, // ✅ NOVO
  });

  /// ✅ Converte o objeto em Map (pra salvar no SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'rua': rua,
      'cruzamento': cruzamento,
      'numero': numero,
      'bairro': bairro,
      'referencia': referencia,
      'desfechoAtendimento': desfechoAtendimento,
      'tipoSinistro': tipoSinistro,
      'sinalizacoesSelecionadas': sinalizacoesSelecionadas ?? [],
      'viatura': viatura,
      'equipe': equipe,
    };
  }

  /// ✅ Constrói o objeto a partir de Map (quando carrega do SharedPreferences)
  factory AgenteInfoRascunho.fromJson(Map<String, dynamic> json) {
    return AgenteInfoRascunho(
      rua: json['rua'],
      cruzamento: json['cruzamento'],
      numero: json['numero'],
      bairro: json['bairro'],
      referencia: json['referencia'],
      desfechoAtendimento: json['desfechoAtendimento'],
      tipoSinistro: json['tipoSinistro'],
      sinalizacoesSelecionadas:
          List<String>.from(json['sinalizacoesSelecionadas'] ?? []),
      viatura: json['viatura'],
      equipe: json['equipe'],
    );
  }

  /// ✅ Permite atualizar apenas os campos desejados
  AgenteInfoRascunho copyWith({
    String? rua,
    String? cruzamento,
    String? numero,
    String? bairro,
    String? referencia,
    String? desfechoAtendimento,
    String? tipoSinistro,
    List<String>? sinalizacoesSelecionadas,
    String? viatura, // ✅ NOVO
    String? equipe, // ✅ NOVO
  }) {
    return AgenteInfoRascunho(
      rua: rua ?? this.rua,
      cruzamento: cruzamento ?? this.cruzamento,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      referencia: referencia ?? this.referencia,
      desfechoAtendimento: desfechoAtendimento ?? this.desfechoAtendimento,
      tipoSinistro: tipoSinistro ?? this.tipoSinistro,
      sinalizacoesSelecionadas:
          sinalizacoesSelecionadas ?? this.sinalizacoesSelecionadas,
      viatura: viatura ?? this.viatura,
      equipe: equipe ?? this.equipe,
    );
  }
}
