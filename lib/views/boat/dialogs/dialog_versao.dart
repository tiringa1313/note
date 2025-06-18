import 'package:flutter/material.dart';

class DialogVersao extends StatefulWidget {
  final String? versaoInicial;
  final void Function(String novaVersao) onSalvar;

  const DialogVersao({
    Key? key,
    this.versaoInicial,
    required this.onSalvar,
  }) : super(key: key);

  @override
  State<DialogVersao> createState() => _DialogVersaoState();
}

class _DialogVersaoState extends State<DialogVersao> {
  late TextEditingController versaoController;

  @override
  void initState() {
    super.initState();
    versaoController = TextEditingController(text: widget.versaoInicial ?? '');
  }

  @override
  void dispose() {
    versaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Versão do Envolvido"),
      content: TextField(
        controller: versaoController,
        maxLines: 6,
        decoration: const InputDecoration(
          hintText: "Digite a versão/depoimento do envolvido",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            widget.onSalvar(versaoController.text);
            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
