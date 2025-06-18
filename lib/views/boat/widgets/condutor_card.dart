import 'package:flutter/material.dart';

class CondutorCard extends StatelessWidget {
  final Map<String, dynamic> condutor;
  final int index;
  final List<String> categorias;
  final Function(int) onEditarPessoa;
  final Function(int) onEditarVeiculo;
  final Function(int) onEditarBicicleta;
  final Function(int) onEditarVersao;
  final Function(int) onEditarSentido; // 🆕 Sentido de deslocamento
  final Function(int, String) onChangeCategoria;

  const CondutorCard({
    super.key,
    required this.condutor,
    required this.index,
    required this.categorias,
    required this.onEditarPessoa,
    required this.onEditarVeiculo,
    required this.onEditarBicicleta,
    required this.onEditarVersao,
    required this.onEditarSentido, // 🆕
    required this.onChangeCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              condutor["nome"],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (condutor["sentido"] != null &&
                condutor["sentido"].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Sentido: ${condutor["sentido"]}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children: [
                  Container(
                    width: 110,
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: condutor["categoria"],
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            onChangeCategoria(index, newValue);
                          }
                        },
                        items: categorias
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ..._buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    List<Widget> buttons = [];

    buttons.add(
      IconButton(
        icon: const Icon(Icons.person_add),
        tooltip: "Editar dados pessoais",
        onPressed: () => onEditarPessoa(index),
      ),
    );

    if (condutor["categoria"] == "Condutor") {
      buttons.addAll([
        IconButton(
          icon: const Icon(Icons.directions_car),
          tooltip: "Veículo envolvido",
          onPressed: () => onEditarVeiculo(index),
        ),
        IconButton(
          icon: const Icon(Icons.comment),
          tooltip: "Versão do envolvido",
          onPressed: () => onEditarVersao(index),
        ),
        IconButton(
          icon: const Icon(Icons.alt_route),
          tooltip: "Sentido de deslocamento",
          onPressed: () => onEditarSentido(index),
        ),
      ]);
    } else if (condutor["categoria"] == "Ciclista") {
      buttons.addAll([
        IconButton(
          icon: const Icon(Icons.directions_bike),
          tooltip: "Bicicleta envolvida",
          onPressed: () => onEditarBicicleta(index),
        ),
        IconButton(
          icon: const Icon(Icons.comment),
          tooltip: "Versão do envolvido",
          onPressed: () => onEditarVersao(index),
        ),
        IconButton(
          icon: const Icon(Icons.alt_route),
          tooltip: "Sentido de deslocamento",
          onPressed: () => onEditarSentido(index),
        ),
      ]);
    } else if (condutor["categoria"] == "Pedestre") {
      buttons.addAll([
        IconButton(
          icon: const Icon(Icons.comment),
          tooltip: "Versão do envolvido",
          onPressed: () => onEditarVersao(index),
        ),
        IconButton(
          icon: const Icon(Icons.alt_route),
          tooltip: "Sentido de deslocamento",
          onPressed: () => onEditarSentido(index),
        ),
      ]);
    }

    return buttons;
  }
}
