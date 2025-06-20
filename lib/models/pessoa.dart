class PessoaModel {
  final String faceId;
  final String nome;
  final String documentoIdentificacao; // Pode ser CPF ou RG
  final String? nomeMae;
  final String? nomePai;
  final String? dataNascimento;
  final String? naturalidade;
  final String? sexo;
  final String? cnhNumero;
  final String? validadeCnh;
  final String? categoriaCnh;
  final String? telefones;
  final String? endereco;
  final String? alcunhas;
  final String? profissao;
  final String? fotoUrl; // URL da imagem (somente leitura)
  final double? similaridade; // Apenas leitura do backend

  PessoaModel({
    required this.faceId,
    required this.nome,
    required this.documentoIdentificacao,
    required this.fotoUrl,
    this.nomeMae,
    this.nomePai,
    this.dataNascimento,
    this.naturalidade,
    this.sexo,
    this.cnhNumero,
    this.validadeCnh,
    this.categoriaCnh,
    this.telefones,
    this.endereco,
    this.alcunhas,
    this.profissao,
    this.similaridade,
  });

  /// Usado ao ENVIAR dados para o backend (cadastrar/atualizar pessoa)
  Map<String, dynamic> toJson() {
    return {
      'faceId': faceId,
      'nome': nome,
      'cpf': documentoIdentificacao, // O backend espera como 'cpf'
      'nomeMae': nomeMae ?? '',
      'nomePai': nomePai ?? '',
      'dataNascimento': dataNascimento ?? '',
      'naturalidade': naturalidade ?? '',
      'sexo': sexo ?? '',
      'cnhNumero': cnhNumero ?? '',
      'validadeCnh': validadeCnh ?? '',
      'categoriaCnh': categoriaCnh ?? '',
      'telefones': telefones ?? '',
      'endereco': endereco ?? '',
      'alcunhas': alcunhas ?? '',
      'profissao': profissao ?? '',
      // 'fotoUrl' não deve ser enviado
    };
  }

  /// Usado ao RECEBER dados do backend (listar/verificar)
  factory PessoaModel.fromJson(Map<String, dynamic> json) {
    final doc = json['cpf'] ?? json['documentoIdentificacao'] ?? '';
    return PessoaModel(
      faceId: json['faceId'] ?? '',
      nome: json['nome'] ?? '',
      documentoIdentificacao: doc,
      fotoUrl: json['fotoUrl'] ?? json['imagem_url'] ?? '',
      nomeMae: json['nomeMae'],
      nomePai: json['nomePai'],
      dataNascimento: json['dataNascimento'],
      naturalidade: json['naturalidade'],
      sexo: json['sexo'],
      cnhNumero: json['cnhNumero'],
      validadeCnh: json['validadeCnh'],
      categoriaCnh: json['categoriaCnh'],
      telefones: json['telefones'],
      endereco: json['endereco'],
      alcunhas: json['alcunhas'],
      profissao: json['profissao'],
      similaridade: (json['similaridade'] != null)
          ? (json['similaridade'] as num).toDouble()
          : null,
    );
  }

  factory PessoaModel.fromMap(Map<String, dynamic> map) =>
      PessoaModel.fromJson(map);

  /// Cria uma cópia alterando apenas `faceId` ou `fotoUrl` (útil após cadastro da imagem)
  PessoaModel copyWith({
    String? faceId,
    String? fotoUrl,
  }) {
    return PessoaModel(
      faceId: faceId ?? this.faceId,
      nome: nome,
      documentoIdentificacao: documentoIdentificacao,
      nomeMae: nomeMae,
      nomePai: nomePai,
      dataNascimento: dataNascimento,
      naturalidade: naturalidade,
      sexo: sexo,
      cnhNumero: cnhNumero,
      validadeCnh: validadeCnh,
      categoriaCnh: categoriaCnh,
      telefones: telefones,
      endereco: endereco,
      alcunhas: alcunhas,
      profissao: profissao,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      similaridade: similaridade,
    );
  }
}
