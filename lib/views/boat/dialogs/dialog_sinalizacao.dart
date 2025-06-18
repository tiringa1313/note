import 'package:flutter/material.dart';

class DialogSinalizacao extends StatefulWidget {
  final List<String> sinalizacoesAtuais;
  final void Function(List<String> novasSinalizacoes, String outrosTexto)
      onSalvar;

  const DialogSinalizacao({
    super.key,
    required this.sinalizacoesAtuais,
    required this.onSalvar,
  });

  @override
  State<DialogSinalizacao> createState() => _DialogSinalizacaoState();
}

class _DialogSinalizacaoState extends State<DialogSinalizacao> {
  late List<String> sinalizacoesSelecionadas;
  late TextEditingController outrosController;

  final List<String> opcoes = [
    "Sem Sinalização",
    "Placa de PARE",
    "Placa de Dê a Preferência",
    "Semáforo Funcionando",
    "Semáforo Inoperante",
    "Faixa de Pedestre",
    "Sinalização de Obras",
    "Outros",
  ];

  @override
  void initState() {
    super.initState();
    sinalizacoesSelecionadas = List<String>.from(widget.sinalizacoesAtuais);
    outrosController = TextEditingController();
  }

  @override
  void dispose() {
    outrosController.dispose();
    super.dispose();
  }

  bool get outrosSelecionado => sinalizacoesSelecionadas.contains("Outros");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sinalização da Via",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: opcoes.length,
                  itemBuilder: (context, index) {
                    final tipo = opcoes[index];
                    return CheckboxListTile(
                      title: Text(
                        tipo,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: sinalizacoesSelecionadas.contains(tipo),
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            sinalizacoesSelecionadas.add(tipo);
                          } else {
                            sinalizacoesSelecionadas.remove(tipo);
                          }
                        });
                      },
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      controlAffinity: ListTileControlAffinity.leading,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
              if (outrosSelecionado) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: outrosController,
                  decoration: const InputDecoration(
                    labelText: "Descrever outra sinalização",
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                ),
              ],
              const SizedBox(height: 16),
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
                      final outrosTexto =
                          outrosSelecionado ? outrosController.text.trim() : '';
                      widget.onSalvar(
                        sinalizacoesSelecionadas,
                        outrosTexto,
                      );
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
