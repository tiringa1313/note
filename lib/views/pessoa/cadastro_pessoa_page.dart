import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:note_gm/models/pessoa.dart';
import 'package:uuid/uuid.dart';

import '../../utils/upper_case_text_formatter.dart'; // importa aqui

class CadastroPessoaPage extends StatefulWidget {
  final Function(PessoaModel) onSalvar;

  const CadastroPessoaPage({required this.onSalvar, super.key});

  @override
  State<CadastroPessoaPage> createState() => _CadastroPessoaPageState();
}

class _CadastroPessoaPageState extends State<CadastroPessoaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _nomeMaeController = TextEditingController();
  final _nomePaiController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _naturalidadeController = TextEditingController();
  final _sexoController = TextEditingController();
  final _cnhNumeroController = TextEditingController();
  final _validadeCnhController = TextEditingController();
  final _categoriaCnhController = TextEditingController();
  final _telefonesController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _alcunhasController = TextEditingController();
  final _profissaoController = TextEditingController();

  // Máscaras
  final _dataMask = MaskTextInputFormatter(mask: '##/##/####');
  final _validadeCnhMask = MaskTextInputFormatter(mask: '##/##/####');

  @override
  void dispose() {
    _nomeController.dispose();
    _documentoController.dispose();
    _nomeMaeController.dispose();
    _nomePaiController.dispose();
    _dataNascimentoController.dispose();
    _naturalidadeController.dispose();
    _sexoController.dispose();
    _cnhNumeroController.dispose();
    _validadeCnhController.dispose();
    _categoriaCnhController.dispose();
    _telefonesController.dispose();
    _enderecoController.dispose();
    _alcunhasController.dispose();
    _profissaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Pessoa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Informações Pessoais',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildTextField(_nomeController, 'Nome completo',
                  obrigatorio: true, upperCase: true),
              _buildTextField(
                _documentoController,
                'CPF ou RG',
                obrigatorio: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              _buildTextField(_nomeMaeController, 'Nome da mãe',
                  upperCase: true),
              _buildTextField(_nomePaiController, 'Nome do pai',
                  upperCase: true),
              _buildTextField(_dataNascimentoController, 'Data de nascimento',
                  inputFormatters: [_dataMask]),
              _buildTextField(_naturalidadeController, 'Naturalidade',
                  upperCase: true),
              _buildTextField(_sexoController, 'Sexo (M/F/O)',
                  upperCase: true, maxLength: 1),
              const SizedBox(height: 20),
              const Text('CNH (opcional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildTextField(_cnhNumeroController, 'Número CNH'),
              _buildTextField(_validadeCnhController, 'Validade CNH',
                  inputFormatters: [_validadeCnhMask]),
              _buildTextField(_categoriaCnhController, 'Categoria CNH',
                  upperCase: true),
              const SizedBox(height: 20),
              _buildTextField(_telefonesController, 'Telefone'),
              _buildTextField(_enderecoController, 'Endereço', upperCase: true),
              _buildTextField(_alcunhasController, 'Alcunhas', upperCase: true),
              _buildTextField(_profissaoController, 'Profissão',
                  upperCase: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // cor de fundo
                    foregroundColor: Colors.white, // cor do texto
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.save, size: 28),
                  label: const Text("CADASTRAR INDIVIDUO"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final pessoa = PessoaModel(
                        faceId: const Uuid().v4(),
                        nome: _nomeController.text,
                        documentoIdentificacao: _documentoController.text,
                        nomeMae: _nomeMaeController.text,
                        nomePai: _nomePaiController.text,
                        dataNascimento: _dataNascimentoController.text,
                        naturalidade: _naturalidadeController.text,
                        sexo: _sexoController.text,
                        cnhNumero: _cnhNumeroController.text,
                        validadeCnh: _validadeCnhController.text,
                        categoriaCnh: _categoriaCnhController.text,
                        telefones: _telefonesController.text,
                        endereco: _enderecoController.text,
                        alcunhas: _alcunhasController.text,
                        profissao: _profissaoController.text,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obrigatorio = false,
    bool upperCase = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        inputFormatters: [
          if (upperCase) UpperCaseTextFormatter(),
          if (inputFormatters != null) ...inputFormatters,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: obrigatorio
            ? (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null
            : null,
      ),
    );
  }
}
