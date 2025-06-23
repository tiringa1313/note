import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_gm/models/pessoa.dart';

class EmbeddingPage extends StatelessWidget {
  final PessoaModel pessoa;
  final String imagePath;

  const EmbeddingPage({
    super.key,
    required this.pessoa,
    required this.imagePath,
  });

  Future<void> _enviarImagem(BuildContext context) async {
    try {
      final file = File(imagePath);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8000/face/adicionar-foto'),
      );
      request.fields['pessoa_id'] = pessoa.id.toString();
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto enviada com sucesso!')),
        );
        Navigator.pop(context, true); // Se quiser retornar algo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar (${response.statusCode})')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar nova imagem'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(child: Image.file(File(imagePath))),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _enviarImagem(context),
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Enviar imagem'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
