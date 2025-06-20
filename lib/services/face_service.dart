import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:note_gm/models/pessoa.dart';
import 'package:path/path.dart' as path;

class FaceService {
  //static const String _baseUrl = 'http://192.168.3.9:8000';
  static const String _baseUrl = 'http://10.0.2.2:8000'; /*emulador*/

  static Future<PessoaModel?> buscarPessoaPorImagem(File image) async {
    try {
      final uri = Uri.parse('$_baseUrl/face/verificar');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          image.path,
          filename: path.basename(image.path),
        ));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(body);
        if (json['encontrado'] == true) {
          return PessoaModel.fromJson(json['pessoa']);
        }
      }

      return null;
    } catch (e) {
      print("❌ Erro ao buscar por imagem: $e");
      return null;
    }
  }

  static Future<void> cadastrarPessoa(File image, PessoaModel pessoa) async {
    try {
      final uri = Uri.parse('$_baseUrl/face/cadastrar');

      final request = http.MultipartRequest('POST', uri)
        ..fields['nome'] = pessoa.nome
        ..fields['cpf'] = pessoa.documentoIdentificacao
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          image.path,
          filename: path.basename(image.path),
        ));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Cadastro enviado com sucesso");
      } else {
        print("❌ Erro ao cadastrar: $body");
      }
    } catch (e) {
      print("❌ Erro no envio da imagem: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> buscarMultiplasCorrespondencias(
      File image) async {
    try {
      final uri = Uri.parse('$_baseUrl/face/similares');
      print('📤 Enviando imagem para: $uri');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          image.path,
          filename: path.basename(image.path),
        ));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      print('📥 Código de status: ${response.statusCode}');
      print('📥 Corpo da resposta: $body');

      if (response.statusCode == 200) {
        final json = jsonDecode(body);
        print('🧠 JSON decodificado: $json');

        // Verifica se o campo correto está presente
        if (json['resultados'] != null && json['resultados'] is List) {
          final List<Map<String, dynamic>> lista =
              List<Map<String, dynamic>>.from(json['resultados']);

          // Ajusta as URLs das imagens
          for (var item in lista) {
            final imagemUrl = item['imagem_url'];
            if (imagemUrl != null &&
                imagemUrl is String &&
                imagemUrl.startsWith('/')) {
              item['imagem_url'] = 'http://192.168.3.9:8000$imagemUrl';
            }
          }

          print('📦 Lista final tratada: $lista');
          return lista;
        } else {
          print('⚠️ Campo "resultados" não encontrado ou não é uma lista.');
        }
      } else {
        print('❌ Erro na resposta da API: ${response.statusCode}');
      }

      return [];
    } catch (e) {
      print("❌ Erro ao buscar múltiplas correspondências: $e");
      return [];
    }
  }
}
