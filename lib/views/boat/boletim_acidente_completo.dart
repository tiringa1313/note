import 'package:note_gm/views/boat/boletim_acidente_rascunho.dart';

class BoletimDeAcidenteCompleto {
  List<BoletimDeAcidenteRascunho> envolvidos;
  String? versaoDoAgente;
  String? local;
  DateTime? dataHora;

  BoletimDeAcidenteCompleto({
    required this.envolvidos,
    this.versaoDoAgente,
    this.local,
    this.dataHora,
  });

  Map<String, dynamic> toJson() => {
        'envolvidos': envolvidos.map((e) => e.toJson()).toList(),
        'versaoDoAgente': versaoDoAgente,
        'local': local,
        'dataHora': dataHora?.toIso8601String(),
      };

  factory BoletimDeAcidenteCompleto.fromJson(Map<String, dynamic> json) {
    return BoletimDeAcidenteCompleto(
      envolvidos: (json['envolvidos'] as List)
          .map((e) => BoletimDeAcidenteRascunho.fromJson(e))
          .toList(),
      versaoDoAgente: json['versaoDoAgente'],
      local: json['local'],
      dataHora:
          json['dataHora'] != null ? DateTime.parse(json['dataHora']) : null,
    );
  }
}
