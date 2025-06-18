import 'package:flutter/material.dart';

class DialogTipoSinistro extends StatefulWidget {
  final String? tipoAtual;
  final void Function(String novoTipo) onSalvar;

  const DialogTipoSinistro({
    super.key,
    required this.tipoAtual,
    required this.onSalvar,
  });

  @override
  State<DialogTipoSinistro> createState() => _DialogTipoSinistroState();
}

class _DialogTipoSinistroState extends State<DialogTipoSinistro> {
  late String tipoSelecionado;

  final List<String> tipos = [
    "Atropelamento de Animal(is)",
    "Atropelamento de Pessoa(s)",
    "Capotamento",
    "Choque com objeto fixo ou móvel sem movimento",
    "Colisão entre veículos em movimento",
    "Colisão Frontal",
    "Colisão Lateral",
    "Colisão Transversal",
    "Colisão Traseira",
    "Engavetamento",
    "Queda de Veículo, Pessoa ou Carga",
    "Tombamento",
  ];

  @override
  void initState() {
    super.initState();
    tipoSelecionado = widget.tipoAtual ?? "";
  }

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
                "Tipo de Sinistro",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: tipos.length,
                  itemBuilder: (context, index) {
                    final tipo = tipos[index];
                    return CheckboxListTile(
                      title: Text(
                        tipo,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: tipoSelecionado == tipo,
                      activeColor: Colors.deepPurple,
                      onChanged: (_) {
                        setState(() {
                          tipoSelecionado = tipo;
                        });
                      },
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
                      widget.onSalvar(tipoSelecionado);
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
