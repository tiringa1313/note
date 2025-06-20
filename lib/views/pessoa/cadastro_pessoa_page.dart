import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_gm/models/pessoa.dart';
import 'package:uuid/uuid.dart';

class CadastroPessoaPage extends StatefulWidget {
  final Function(PessoaModel) onSalvar;

  const CadastroPessoaPage({required this.onSalvar, super.key});

  @override
  State<CadastroPessoaPage> createState() => _CadastroPessoaPageState();
}

class _CadastroPessoaPageState extends State<CadastroPessoaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Rápido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Preencha os dados para cadastrar a pessoa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [UpperCaseTextFormatter()],
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text("Cadastrar Pessoa"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final pessoa = PessoaModel(
                        faceId: const Uuid().v4(),
                        nome: _nomeController.text,
                        documentoIdentificacao: _cpfController.text,
                        fotoUrl: '',
                      );

                      widget.onSalvar(pessoa);
                      Navigator.pop(context, 'sucesso');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
