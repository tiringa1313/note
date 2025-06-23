import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note_gm/models/pessoa.dart';
import 'package:note_gm/views/pessoa/embedding_page.dart';
import 'package:note_gm/views/pessoa/grafo_relacionamentos_widget.dart';

class DetalhesPessoaPage extends StatelessWidget {
  final PessoaModel pessoa;

  const DetalhesPessoaPage({super.key, required this.pessoa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4753C9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            pessoa.nome,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.add_a_photo, color: Colors.white),
              tooltip: 'Nova foto',
              onPressed: () {
                if (pessoa.fotoFilePath == null ||
                    pessoa.fotoFilePath!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nenhuma foto disponível para enviar'),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmbeddingPage(
                      pessoa: pessoa,
                      imagePath: pessoa.fotoFilePath ?? '',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: 82,
            decoration: const BoxDecoration(
              color: Color(0xFF4753C9),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 140,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: pessoa.fotoFilePath != null &&
                              pessoa.fotoFilePath!.isNotEmpty
                          ? Image.file(
                              File(pessoa.fotoFilePath!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 60),
                            )
                          : (pessoa.fotoUrl != null &&
                                  pessoa.fotoUrl!.isNotEmpty)
                              ? Image.network(
                                  pessoa.fotoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 60),
                                  loadingBuilder: (_, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                )
                              : const Icon(Icons.person,
                                  size: 60, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    indicatorColor: Color(0xFF4753C9),
                    indicatorWeight: 3,
                    labelColor: Color(0xFF4753C9),
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Informações'),
                      Tab(text: 'Relacionamentos'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _linha(
                                "CPF", pessoa.documentoIdentificacao ?? '---'),
                            _linha("Data de Nascimento",
                                pessoa.dataNascimento ?? '---'),
                            _linha("Sexo", pessoa.sexo ?? '---'),
                            _linha(
                                "Naturalidade", pessoa.naturalidade ?? '---'),
                            _linha("Nome da Mãe", pessoa.nomeMae ?? '---'),
                            _linha("Nome do Pai", pessoa.nomePai ?? '---'),
                            _linha("Profissão", pessoa.profissao ?? '---'),
                            _linha("CNH", pessoa.cnhNumero ?? '---'),
                            _linha("Validade CNH", pessoa.validadeCnh ?? '---'),
                            _linha(
                                "Categoria CNH", pessoa.categoriaCnh ?? '---'),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Color(0xFFF8F2FF),
                        child: GrafoRelacionamentosWidget(
                          pessoaCentral: pessoa.nome,
                          relacionados: ['João', 'Maria', 'Carlos', 'Ana'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linha(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$titulo: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
