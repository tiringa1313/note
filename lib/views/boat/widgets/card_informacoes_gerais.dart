import 'package:flutter/material.dart';

class CardInformacoesGerais extends StatelessWidget {
  final VoidCallback onEditarEndereco;
  final VoidCallback onEditarDesfecho;
  final VoidCallback onEditarTipoSinistro;
  final VoidCallback onEditarSinalizacao;

  final bool enderecoPreenchido;
  final bool desfechoPreenchido;
  final bool tipoSinistroPreenchido;
  final bool sinalizacaoPreenchida;

  const CardInformacoesGerais({
    super.key,
    required this.onEditarEndereco,
    required this.onEditarDesfecho,
    required this.onEditarTipoSinistro,
    required this.onEditarSinalizacao,
    required this.enderecoPreenchido,
    required this.desfechoPreenchido,
    required this.tipoSinistroPreenchido,
    required this.sinalizacaoPreenchida,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple[50],
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dados Essenciais",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children: [
                  const SizedBox(width: 110, height: 32),
                  const SizedBox(width: 8),
                  _buildIconButton(
                    icon: Icons.map,
                    tooltip: 'Endereço do Acidente',
                    preenchido: enderecoPreenchido,
                    onPressed: onEditarEndereco,
                  ),
                  _buildIconButton(
                    icon: Icons.note_alt,
                    tooltip: 'Desfecho do Atendimento',
                    preenchido: desfechoPreenchido,
                    onPressed: onEditarDesfecho,
                  ),
                  _buildIconButton(
                    icon: Icons.car_crash,
                    tooltip: 'Tipo de Sinistro',
                    preenchido: tipoSinistroPreenchido,
                    onPressed: onEditarTipoSinistro,
                  ),
                  _buildIconButton(
                    icon: Icons.traffic,
                    tooltip: 'Sinalização da Via',
                    preenchido: sinalizacaoPreenchida,
                    onPressed: onEditarSinalizacao,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Método auxiliar para construir os botões com V verde se preenchido
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required bool preenchido,
    required VoidCallback onPressed,
  }) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          iconSize: 32,
          tooltip: tooltip,
          icon: Icon(icon, color: Colors.deepPurple),
          onPressed: onPressed,
        ),
        if (preenchido)
          const Positioned(
            top: 4,
            right: 4,
            child: Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green,
            ),
          ),
      ],
    );
  }
}
