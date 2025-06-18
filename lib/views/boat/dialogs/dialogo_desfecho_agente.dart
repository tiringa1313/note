import 'package:flutter/material.dart';

class DialogDesfechoAgente extends StatefulWidget {
  final String? desfechoInicial;
  final void Function(String novoDesfecho) onSalvar;

  const DialogDesfechoAgente({
    super.key,
    this.desfechoInicial,
    required this.onSalvar,
  });

  @override
  State<DialogDesfechoAgente> createState() => _DialogDesfechoAgenteState();
}

class _DialogDesfechoAgenteState extends State<DialogDesfechoAgente> {
  late TextEditingController desfechoController;

  @override
  void initState() {
    super.initState();
    desfechoController =
        TextEditingController(text: widget.desfechoInicial ?? '');
  }

  @override
  void dispose() {
    desfechoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        // ✅ Evita overflow ao abrir teclado
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
            minHeight: 400, // ✅ Deixei o Dialog um pouco mais alto
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Desfecho do Atendimento",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // ✅ TextField expandindo para altura melhor
                SizedBox(
                  height: 220, // ✅ Altura confortável da caixa de texto
                  child: TextField(
                    controller: desfechoController,
                    maxLines: 8, // ✅ 8 linhas visíveis fixas
                    decoration: const InputDecoration(
                      hintText: "Descreva como o atendimento foi finalizado...",
                      border: OutlineInputBorder(),
                      alignLabelWithHint:
                          true, // ✅ Garante alinhamento do label com o início do campo
                    ),
                    textInputAction: TextInputAction.newline,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (desfechoController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Descreva o desfecho do atendimento.")),
                          );
                          return;
                        }
                        widget.onSalvar(desfechoController.text.trim());
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
      ),
    );
  }
}
