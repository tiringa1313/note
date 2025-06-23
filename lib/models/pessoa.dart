class PessoaModel {
  final int? id; // Corrigido aqui
  final String faceId;
  final String nome;
  final String documentoIdentificacao;
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
  final String? fotoUrl;
  final double? similaridade;
  final String? fotoFilePath;

  PessoaModel({
    required this.id,
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
    this.fotoFilePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faceId': faceId,
      'nome': nome,
      'cpf': documentoIdentificacao,
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
    };
  }

  factory PessoaModel.fromJson(Map<String, dynamic> json) {
    final doc = json['cpf'] ?? json['documentoIdentificacao'] ?? '';
    return PessoaModel(
      id: int.tryParse(json['pessoa_id'].toString()),
      faceId: json['faceId'] ?? '',
      nome: json['nome'] ?? '',
      documentoIdentificacao: doc,
      fotoUrl: (json['fotoUrl'] ?? json['imagem_url'])?.toString(),

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
      fotoFilePath: null, // Local, não vem da API
    );
  }

  factory PessoaModel.fromMap(Map<String, dynamic> map) =>
      PessoaModel.fromJson(map);

  PessoaModel copyWith({
    int? id,
    String? faceId,
    String? fotoUrl,
    String? fotoFilePath,
    double? similaridade,
  }) {
    return PessoaModel(
      id: id ?? this.id,
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
      similaridade: similaridade ?? this.similaridade,
      fotoFilePath: fotoFilePath ?? this.fotoFilePath,
    );
  }
}
