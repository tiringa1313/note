import 'package:flutter/material.dart';

class DialogVersaoAgente extends StatefulWidget {
  final String? versaoInicial;
  final void Function(String novaVersao) onSalvar;

  const DialogVersaoAgente({
    super.key,
    this.versaoInicial,
    required this.onSalvar,
  });

  @override
  State<DialogVersaoAgente> createState() => _DialogVersaoAgenteState();
}

class _DialogVersaoAgenteState extends State<DialogVersaoAgente> {
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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 450, // ✅ Deixamos mais largo
          minHeight: 300, // ✅ Deixamos mais alto
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Desfecho do Atendimento",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: versaoController,
                maxLines: 8, // ✅ Campo maior para digitar confortável
                decoration: const InputDecoration(
                  hintText: "Descreva como o atendimento foi finalizado...",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (versaoController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Descreva o desfecho.")),
                        );
                        return;
                      }
                      widget.onSalvar(versaoController.text.trim());
                      Navigator.pop(context);
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
