import 'package:flutter/material.dart';

class DialogBicicleta extends StatefulWidget {
  final Function({
    required String modelo,
    required String quadro,
    required String cor,
    required String danos,
  }) onSalvar;

  final String? modeloInicial;
  final String? quadroInicial;
  final String? corInicial;
  final String? danosIniciais;

  const DialogBicicleta({
    required this.onSalvar,
    this.modeloInicial,
    this.quadroInicial,
    this.corInicial,
    this.danosIniciais,
    super.key,
  });

  @override
  State<DialogBicicleta> createState() => _DialogBicicletaState();
}

class _DialogBicicletaState extends State<DialogBicicleta> {
  late TextEditingController modeloController;
  late TextEditingController quadroController;
  late TextEditingController corController;
  late TextEditingController danosController;

  @override
  void initState() {
    super.initState();
    modeloController = TextEditingController(text: widget.modeloInicial ?? '');
    quadroController = TextEditingController(text: widget.quadroInicial ?? '');
    corController = TextEditingController(text: widget.corInicial ?? '');
    danosController = TextEditingController(text: widget.danosIniciais ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Cadastro de Bicicleta",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField(
                  "Marca / Modelo", modeloController, Icons.pedal_bike),
              _buildTextField("Número do Quadro", quadroController,
                  Icons.confirmation_number),
              _buildTextField("Cor", corController, Icons.color_lens),
              TextField(
                controller: danosController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Danos observados",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Ex: aro torto, pedal quebrado...",
                ),
              ),
              const SizedBox(height: 16),
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
                        quadro: quadroController.text,
                        cor: corController.text,
                        danos: danosController.text,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
