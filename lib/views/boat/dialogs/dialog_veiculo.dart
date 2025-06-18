import 'package:flutter/material.dart';

class DialogVeiculo extends StatefulWidget {
  final Function({
    required String modelo,
    required String placa,
    required String cor,
    required String danos,
    required String tipo,
  }) onSalvar;

  final String? modeloInicial;
  final String? placaInicial;
  final String? corInicial;
  final String? danosIniciais;
  final String? tipoInicial;

  const DialogVeiculo({
    required this.onSalvar,
    this.modeloInicial,
    this.placaInicial,
    this.corInicial,
    this.danosIniciais,
    this.tipoInicial,
    super.key,
  });

  @override
  State<DialogVeiculo> createState() => _DialogVeiculoState();
}

class _DialogVeiculoState extends State<DialogVeiculo> {
  late TextEditingController modeloController;
  late TextEditingController placaController;
  late TextEditingController corController;
  late TextEditingController danosController;

  String tipoSelecionado = 'Outro';

  @override
  void initState() {
    super.initState();
    modeloController = TextEditingController(text: widget.modeloInicial ?? '');
    placaController = TextEditingController(text: widget.placaInicial ?? '');
    corController = TextEditingController(text: widget.corInicial ?? '');
    danosController = TextEditingController(text: widget.danosIniciais ?? '');
    tipoSelecionado = widget.tipoInicial ?? 'Outro';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 400), // Limita em telas grandes
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Cadastro de Veículo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCheckbox("Carro", "Carro"),
                    _buildCheckbox("Moto", "Moto"),
                    _buildCheckbox("Motoneta", "Motoneta"),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTextField("Placa", placaController, Icons.assignment),
                _buildTextField(
                    "Marca/Modelo", modeloController, Icons.car_repair),
                _buildTextField("Cor", corController, Icons.color_lens),
                TextField(
                  controller: danosController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: "Danos do veículo",
                    border: OutlineInputBorder(),
                    hintText: "Descreva os danos do veículo",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: const Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text("Salvar"),
                      onPressed: () {
                        widget.onSalvar(
                          modelo: modeloController.text,
                          placa: placaController.text,
                          cor: corController.text,
                          danos: danosController.text,
                          tipo: tipoSelecionado,
                        );
                        Navigator.pop(context);
                      },
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

  Widget _buildCheckbox(String label, String tipo) {
    return Row(
      children: [
        Checkbox(
          value: tipoSelecionado == tipo,
          onChanged: (_) => setState(() => tipoSelecionado = tipo),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
