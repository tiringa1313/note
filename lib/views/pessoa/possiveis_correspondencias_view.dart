import 'package:flutter/material.dart';
import 'package:note_gm/models/pessoa.dart';

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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(pessoa.fotoUrl ?? ''),
                    radius: 28,
                    backgroundColor: Colors.grey[200],
                  ),
                  title: Text(
                    pessoa.nome,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Doc: ${pessoa.documentoIdentificacao ?? '---'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Similaridade: $similaridadeStr%',
                        style: TextStyle(
                          fontSize: 14,
                          color: corSimilaridade,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirmar"),
                        content: Text(
                          "Confirmar que ${pessoa.nome} é a mesma pessoa?",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            child: const Text("Confirmar"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context, pessoa);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${pessoa.nome} confirmada."),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  onPressed: onCadastrarNovo,
                  icon: const Icon(Icons.person_add),
                  label: const Text("Não é nenhum desses – Cadastrar novo"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
