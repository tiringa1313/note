import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/placa_veiculo.dart';

class RegistrarAbordagemView extends StatefulWidget {
  final PlacaVeiculo placaVeiculo;

  RegistrarAbordagemView({required this.placaVeiculo});

  @override
  _RegistrarAbordagemViewState createState() => _RegistrarAbordagemViewState();
}

class _RegistrarAbordagemViewState extends State<RegistrarAbordagemView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _condutorController = TextEditingController();
  TextEditingController _observacoesController = TextEditingController();
  DateTime _dataAbordagem = DateTime.now();

  // Função para salvar a abordagem no banco
  Future<void> _salvarAbordagem() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Salvar a abordagem no banco (aqui você implementará a lógica de inserção)
      // Exemplo: await _dbHelper.salvarAbordagem(novaAbordagem);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Abordagem registrada com sucesso!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Abordagem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Placa: ${widget.placaVeiculo.placa}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              // Campo para o condutor
              TextFormField(
                controller: _condutorController,
                decoration: InputDecoration(labelText: 'Condutor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do condutor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Campo para a data da abordagem
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Data da Abordagem',
                    hintText: 'Selecione a data',
                    suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dataAbordagem,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != _dataAbordagem) {
                    setState(() {
                      _dataAbordagem = picked!;
                    });
                  }
                },
                controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(_dataAbordagem)),
              ),
              SizedBox(height: 20),
              // Campo para observações
              TextFormField(
                controller: _observacoesController,
                decoration:
                    InputDecoration(labelText: 'Observações (opcional)'),
              ),
              SizedBox(height: 20),
              // Botão para salvar a abordagem
              ElevatedButton(
                onPressed: _salvarAbordagem,
                child: Text('Salvar Abordagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
