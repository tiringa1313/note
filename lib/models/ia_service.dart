import 'dart:convert';
import 'package:http/http.dart' as http;

class IAService {
  final String apiKey =
      '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';
  final String url = 'https://api.openai.com/v1/chat/completions';

  Future<String> corrigirTexto(String descricao, String instrucoes) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': instrucoes,
          },
          {
            'role': 'user',
            'content': descricao,
          }
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
        'n': 1,
        'stop': null,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final corrigido = data['choices'][0]['message']['content'];
      return corrigido.trim();
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(
          'Falha ao corrigir o texto: ${response.reasonPhrase}. Detalhes: ${errorData['error']['message']}');
    }
  }

  Future<String> gerarBoat({
    required String local,
    required String data,
    required String hora,
    required String viaturaEquipe,
    required String tipoSinistro,
    required List<Map<String, String>> envolvidos,
    required String conclusao,
  }) async {
    final prompt = _gerarPromptBoat(
      local: local,
      data: data,
      hora: hora,
      viaturaEquipe: viaturaEquipe,
      tipoSinistro: tipoSinistro,
      envolvidos: envolvidos,
      conclusao: conclusao,
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                'Você é um agente da Guarda Municipal responsável por redigir boletins de atendimento de trânsito de forma clara, formal, objetiva e contínua, sem criar cabeçalhos, listas ou tópicos.'
          },
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Erro ao gerar BOAT: ${errorData['error']['message']}');
    }
  }

  String _gerarPromptBoat({
    required String local,
    required String data,
    required String hora,
    required String viaturaEquipe,
    required String tipoSinistro,
    required List<Map<String, String>> envolvidos,
    required String conclusao,
  }) {
    final buffer = StringBuffer();

    buffer.writeln(
        "Por volta das $hora do dia $data, a guarnição da $viaturaEquipe foi acionada para atender uma solicitação de $tipoSinistro no endereço $local.");

    if (envolvidos.isNotEmpty) {
      final envolvidosValidos = envolvidos
          .where((e) => e['nome'] != null && e['nome']!.isNotEmpty)
          .toList();

      if (envolvidosValidos.isNotEmpty) {
        if (envolvidosValidos.length == 1) {
          final e = envolvidosValidos.first;
          buffer.writeln(
              "No local, verificou-se que ${_formatarNome(e['nome'])}, portador(a) da CNH ${e['cnh']}, conduzia um ${e['veiculo']} de placa ${e['placa']}, trafegando no sentido ${e['sentido']}.");
        } else {
          buffer.write("No local, verificou-se que ");
          for (int i = 0; i < envolvidosValidos.length; i++) {
            final e = envolvidosValidos[i];
            buffer.write(
                "${_formatarNome(e['nome'])}, portador(a) da CNH ${e['cnh']}, conduzia um ${e['veiculo']} de placa ${e['placa']}, trafegando no sentido ${e['sentido']}");
            if (i < envolvidosValidos.length - 1) {
              buffer.write(", enquanto ");
            } else {
              buffer.write(".");
            }
          }
        }

        // Relatos
        for (var e in envolvidosValidos) {
          final versao = e['versao'] ?? '';
          if (versao.isNotEmpty && versao != "Sem relato fornecido") {
            buffer.writeln(" ${_formatarNome(e['nome'])} relatou que $versao.");
          }
        }
      }
    }

    buffer.writeln(conclusao.trim());
    buffer.writeln(
        "Diante dos fatos, a guarnição realizou a orientação a cerca dos procedimentos legais cabíveis, liberou a via e encerrou o atendimento.");

    return buffer.toString();
  }

  /// Função para corrigir nomes (primeira letra maiúscula)
  String _formatarNome(String? nome) {
    if (nome == null || nome.isEmpty) return "";
    return nome[0].toUpperCase() + nome.substring(1).toLowerCase();
  }
}
