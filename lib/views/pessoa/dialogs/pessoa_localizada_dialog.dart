import 'package:flutter/material.dart';
import 'package:note_gm/models/pessoa.dart';

class PessoaLocalizadaDialog extends StatelessWidget {
  final PessoaModel pessoa;

  const PessoaLocalizadaDialog({required this.pessoa, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.person_search, color: Colors.green),
          SizedBox(width: 8),
          Text('Pessoa localizada'),
        ],
      ),
      content: SingleChildScrollView(
        // <<<<<< Adicionado scroll aqui
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pessoa.fotoUrl != null && pessoa.fotoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pessoa.fotoUrl!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            _buildInfoRow('Nome', pessoa.nome),
            _buildInfoRow('Documento', pessoa.documentoIdentificacao),
            _buildInfoRow(
                'Nascimento', pessoa.dataNascimento ?? 'Não informado'),
            _buildInfoRow(
                'Sexo', pessoa.sexo?.toUpperCase() ?? 'Não informado'),
            _buildInfoRow('Telefone', pessoa.telefones ?? 'Não informado'),
            _buildInfoRow('Profissão', pessoa.profissao ?? 'Não informado'),
            _buildInfoRow('Endereço', pessoa.endereco ?? 'Não informado'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
