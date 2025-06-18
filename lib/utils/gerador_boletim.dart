import 'package:note_gm/views/boat/boletim_acidente_completo.dart';

String gerarTextoDoBoletim(BoletimDeAcidenteCompleto boletim) {
  final buffer = StringBuffer();

  buffer.writeln("📝 BOLETIM DE OCORRÊNCIA DE ACIDENTE DE TRÂNSITO\n");
  buffer.writeln("📍 Local: ${boletim.local ?? "Não informado"}");
  buffer.writeln(
      "🕒 Data/Hora: ${boletim.dataHora?.toString() ?? "Não informada"}\n");
  buffer.writeln("🚗 Envolvidos:");

  for (int i = 0; i < boletim.envolvidos.length; i++) {
    final e = boletim.envolvidos[i];
    buffer.writeln("\n🔹 Envolvido ${i + 1}:");
    buffer.writeln("  - Nome: ${e.nomeCondutor ?? "—"}");
    buffer.writeln("  - CPF: ${e.cpfCondutor ?? "—"}");
    buffer.writeln("  - CNH: ${e.cnhCondutor ?? "—"}");
    buffer.writeln("  - Placa: ${e.placa ?? "—"}");
    buffer.writeln("  - Modelo: ${e.modelo ?? "—"}");
    buffer.writeln("  - Cor: ${e.cor ?? "—"}");
    buffer.writeln("  - Sentido: ${e.sentidoDeslocamento ?? "—"}");
    buffer.writeln("  - Versão: ${e.versaoDoCondutor ?? "—"}");
  }

  buffer.writeln("\n📌 Versão do Agente:\n${boletim.versaoDoAgente ?? "—"}");

  return buffer.toString();
}
