import 'package:flutter/material.dart';
import 'package:note_gm/models/pessoa.dart';
import 'package:note_gm/views/pessoa/DetalhesPessoaPage.dart';

class PossiveisCorrespondenciasView extends StatelessWidget {
  final List<Map<String, dynamic>> correspondencias;
  final VoidCallback onCadastrarNovo;

  const PossiveisCorrespondenciasView({
    required this.correspondencias,
    required this.onCadastrarNovo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Possíveis Correspondências")),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: correspondencias.length + 1,
          itemBuilder: (context, index) {
            if (index < correspondencias.length) {
              final item = correspondencias[index];

              // Verifica se item é válido
              if (item == null || item is! Map<String, dynamic>) {
                return const Text('❌ Item inválido.');
              }

              final pessoa = PessoaModel.fromJson(item);
              final similaridadeNum = item['similaridade'] as double? ?? 0.0;
              final similaridadeStr =
                  (similaridadeNum * 100).toStringAsFixed(1);

              final corSimilaridade = similaridadeNum >= 0.9
                  ? Colors.green
                  : (similaridadeNum >= 0.75 ? Colors.orange : Colors.red);

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18), // Aumente o vertical aqui!

                  //campoo da foto do individuo
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: pessoa.fotoUrl != null && pessoa.fotoUrl!.isNotEmpty
                        ? Image.network(
                            pessoa.fotoUrl!,
                            width: 60,
                            height:
                                120, // Mantenha a altura desejada para a imagem
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 120, // Mantenha a altura desejada
                              color: Colors.grey,
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 120, // Mantenha a altura desejada
                            color: Colors.grey,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                  ),
                  title: Text(
                    pessoa.nome,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      // Documento
                      Text(
                        'Doc: ${pessoa.documentoIdentificacao ?? '---'}',
                        style: const TextStyle(fontSize: 14),
                      ),

                      // Similaridade textual
                      Text(
                        'Similaridade: $similaridadeStr%',
                        style: TextStyle(
                          fontSize: 14,
                          color: corSimilaridade,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Barra visual de similaridade
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: similaridadeNum, // entre 0.0 e 1.0
                        backgroundColor: Colors.grey[300],
                        color: corSimilaridade,
                        minHeight: 6,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhesPessoaPage(pessoa: pessoa),
                      ),
                    );

                    // Após voltar da página de detalhes, fecha a lista
                    Navigator.pop(context, pessoa);
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  onPressed: onCadastrarNovo,
                  icon: const Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Não é nenhum desses – Cadastrar novo",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:
                        Colors.indigo[800], // mesmo tom do botão da galeria
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
