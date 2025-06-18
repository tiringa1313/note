import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // necessário para inputFormatters

// 🔥 Formatter para deixar texto MAIÚSCULO
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// 🔥 Dialog para cadastrar o endereço
class DialogEnderecoAcidente extends StatefulWidget {
  final String? ruaAtual;
  final String? cruzamentoAtual;
  final String? numeroAtual;
  final String? bairroAtual;
  final String? referenciaAtual;
  final void Function({
    required String rua,
    String? cruzamento,
    String? numero,
    String? bairro,
    String? referencia,
  }) onSalvar;

  const DialogEnderecoAcidente({
    super.key,
    this.ruaAtual,
    this.cruzamentoAtual,
    this.numeroAtual,
    this.bairroAtual,
    this.referenciaAtual,
    required this.onSalvar,
  });

  @override
  State<DialogEnderecoAcidente> createState() => _DialogEnderecoAcidenteState();
}

class _DialogEnderecoAcidenteState extends State<DialogEnderecoAcidente> {
  late TextEditingController ruaController;
  late TextEditingController cruzamentoController;
  late TextEditingController numeroController;
  late TextEditingController bairroController;
  late TextEditingController referenciaController;

  @override
  void initState() {
    super.initState();
    ruaController = TextEditingController(text: widget.ruaAtual ?? '');
    cruzamentoController =
        TextEditingController(text: widget.cruzamentoAtual ?? '');
    numeroController = TextEditingController(text: widget.numeroAtual ?? '');
    bairroController = TextEditingController(text: widget.bairroAtual ?? '');
    referenciaController =
        TextEditingController(text: widget.referenciaAtual ?? '');
  }

  @override
  void dispose() {
    ruaController.dispose();
    cruzamentoController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    referenciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Endereço do Acidente",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ruaController,
                  decoration: const InputDecoration(
                    labelText: "Rua Principal / Avenida *",
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cruzamentoController,
                  decoration: const InputDecoration(
                    labelText: "Rua Cruzada (se cruzamento)",
                    prefixIcon: Icon(Icons.alt_route),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(
                    labelText: "Número ou KM",
                    prefixIcon: Icon(Icons.pin_drop),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(
                    labelText: "Bairro",
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: referenciaController,
                  decoration: const InputDecoration(
                    labelText: "Ponto de Referência",
                    prefixIcon: Icon(Icons.place),
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [UpperCaseTextFormatter()],
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
                      onPressed: () {
                        if (ruaController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Informe a rua principal.")),
                          );
                          return;
                        }
                        widget.onSalvar(
                          rua: ruaController.text.trim(),
                          cruzamento: cruzamentoController.text.trim().isEmpty
                              ? null
                              : cruzamentoController.text.trim(),
                          numero: numeroController.text.trim().isEmpty
                              ? null
                              : numeroController.text.trim(),
                          bairro: bairroController.text.trim().isEmpty
                              ? null
                              : bairroController.text.trim(),
                          referencia: referenciaController.text.trim().isEmpty
                              ? null
                              : referenciaController.text.trim(),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
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
