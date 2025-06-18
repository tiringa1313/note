import 'package:flutter/material.dart';

class DialogOrientacao extends StatefulWidget {
  final String? sentidoInicial;
  final String? ruaInicial;
  final List<String> listaDeRuas;
  final void Function(String sentido, String ruaSelecionada) onSalvar;

  const DialogOrientacao({
    super.key,
    this.sentidoInicial,
    this.ruaInicial,
    required this.listaDeRuas,
    required this.onSalvar,
  });

  @override
  State<DialogOrientacao> createState() => _DialogOrientacaoState();
}

class _DialogOrientacaoState extends State<DialogOrientacao> {
  String? sentidoSelecionado;
  String? ruaSelecionada;

  final List<String> opcoesSentido = [
    "NORTE-SUL",
    "SUL-NORTE",
    "LESTE-OESTE",
    "OESTE-LESTE",
  ];

  @override
  void initState() {
    super.initState();
    sentidoSelecionado = widget.sentidoInicial;
    ruaSelecionada = widget.ruaInicial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rua e Sentido do Deslocamento"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 Primeiro o Dropdown da Rua
            DropdownButtonFormField<String>(
              value: ruaSelecionada,
              decoration: const InputDecoration(
                labelText: 'Seguia pela rua:',
                border: OutlineInputBorder(),
              ),
              items: widget.listaDeRuas.map((rua) {
                return DropdownMenuItem(
                  value: rua,
                  child: Text(rua),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  ruaSelecionada = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // 🔥 Depois os Radios de Sentido
            ...opcoesSentido.map((sentido) {
              return RadioListTile<String>(
                title: Text(sentido),
                value: sentido,
                groupValue: sentidoSelecionado,
                onChanged: (value) {
                  setState(() {
                    sentidoSelecionado = value;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (sentidoSelecionado != null && ruaSelecionada != null) {
              widget.onSalvar(sentidoSelecionado!, ruaSelecionada!);
              Navigator.pop(context);
            }
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
