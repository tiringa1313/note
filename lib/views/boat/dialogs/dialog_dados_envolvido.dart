import 'package:flutter/material.dart';
import 'package:note_gm/views/boat/boletim_acidente_rascunho.dart';

class DialogDadosEnvolvido extends StatefulWidget {
  final BoletimDeAcidenteRascunho rascunho;
  final void Function(BoletimDeAcidenteRascunho rascunhoAtualizado) onSalvar;
  final List<String> listaDeRuas; // 🔥 NOVO

  const DialogDadosEnvolvido({
    Key? key,
    required this.rascunho,
    required this.onSalvar,
    required this.listaDeRuas, // 🔥 NOVO
  }) : super(key: key);

  @override
  State<DialogDadosEnvolvido> createState() => _DialogDadosEnvolvidoState();
}

class _DialogDadosEnvolvidoState extends State<DialogDadosEnvolvido> {
  late TextEditingController nomeController;
  late TextEditingController cnhController;
  late TextEditingController cpfController;
  String? ruaSelecionada;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(
      text: widget.rascunho.nomeCondutor?.startsWith("Envolvido") ?? false
          ? ""
          : widget.rascunho.nomeCondutor ?? '',
    );
    cnhController =
        TextEditingController(text: widget.rascunho.cnhCondutor ?? '');
    cpfController =
        TextEditingController(text: widget.rascunho.cpfCondutor ?? '');
    ruaSelecionada = widget.rascunho.ruaSelecionada; // 🔥 Se já tiver salvo
  }

  void _atualizarRascunho() {
    widget.rascunho.nomeCondutor = nomeController.text;
    widget.rascunho.cnhCondutor = cnhController.text;
    widget.rascunho.cpfCondutor = cpfController.text;
    widget.rascunho.ruaSelecionada =
        ruaSelecionada; // 🔥 Salva a rua selecionada
  }

  @override
  void dispose() {
    nomeController.dispose();
    cnhController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          // 🔥 Garante que tudo aparece em telas menores
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Dados Envolvido",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField("Nome completo", nomeController, Icons.person),
              _buildTextField("CNH", cnhController, Icons.credit_card),
              _buildTextField("CPF", cpfController, Icons.assignment_ind),
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
                      _atualizarRascunho();
                      widget.onSalvar(widget.rascunho);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(icon),
          hintText: "Digite $label",
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
