import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_gm/models/database_helper.dart';

import '../models/placa_veiculo.dart';
import 'registrar_abordagem_view.dart';

class DetalhesPlacaView extends StatefulWidget {
  final PlacaVeiculo placaVeiculo;

  DetalhesPlacaView({required this.placaVeiculo});

  @override
  _DetalhesPlacaViewState createState() => _DetalhesPlacaViewState();
}

class _DetalhesPlacaViewState extends State<DetalhesPlacaView> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  PlacaVeiculo? _veiculoDetalhes; // Alterado para permitir null no início

  @override
  void initState() {
    super.initState();
    _fetchDadosVeiculo(); // Recuperar dados do veículo ao iniciar a view
  }

  Future<void> _fetchDadosVeiculo() async {
    try {
      final veiculo =
          await _dbHelper.getPlacaDetails(widget.placaVeiculo.placa);
      setState(() {
        _veiculoDetalhes = veiculo; // Atribuindo os dados carregados
      });
    } catch (e) {
      print("Erro ao buscar dados do veículo: $e");
      // Você pode exibir uma mensagem de erro aqui, caso necessário.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Placa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _veiculoDetalhes == null
            ? Center(
                child:
                    CircularProgressIndicator()) // Indicador enquanto carrega
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Alinha os itens no topo
                        children: [
                          // Coluna com as informações de texto
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _veiculoDetalhes!.placa,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Marca: ${_veiculoDetalhes!.marca}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Modelo: ${_veiculoDetalhes!.modelo}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Ano: ${_veiculoDetalhes!.ano}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Chassi: ${_veiculoDetalhes!.chassi}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          // Imagem do veículo
                          SizedBox(
                              width: 16), // Espaçamento entre texto e imagem
                          Container(
                            width: 120, // Largura fixa para a imagem
                            height: 140, // Altura fixa para a imagem
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _veiculoDetalhes!.fotoVeiculo != null
                                    ? FileImage(
                                        File(_veiculoDetalhes!.fotoVeiculo!))
                                    : AssetImage('assets/default_image.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(
                                  8), // Bordas arredondadas
                              border: Border.all(
                                color: Colors.grey, // Cor da borda
                                width: 2, // Largura da borda
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Espaço para o título "Histórico de Abordagens"
                  SizedBox(height: 20),
                  Text(
                    "Histórico de Abordagens",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialog(context); // Abre o dialog ao pressionar o FAB
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 247, 213, 21),
      ),
    );
  }

  void _mostrarDialog(BuildContext context) {
    final TextEditingController condutorController = TextEditingController();
    final TextEditingController documentoController = TextEditingController();
    final TextEditingController observacaoController = TextEditingController();
    bool possuiCNH = true; // Valor padrão

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Registrar Abordagem',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Placa: ${widget.placaVeiculo.placa}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 12),
                      _buildTextField(condutorController, 'Nome do Condutor'),

                      // Checkbox antes do campo de documento
                      Row(
                        children: [
                          Checkbox(
                            value: possuiCNH,
                            onChanged: (bool? value) {
                              setState(() {
                                possuiCNH = value ?? true;
                                documentoController
                                    .clear(); // Limpa o campo ao mudar a opção
                              });
                            },
                          ),
                          Text(
                            "Condutor possui CNH",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      // Campo único para CNH ou CPF
                      _buildTextField(
                        documentoController,
                        possuiCNH ? 'CNH do Condutor' : 'CPF do Condutor',
                      ),

                      _buildTextField(observacaoController, 'Motivo Abordagem',
                          maxLines: 5),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar',
                                style: TextStyle(fontSize: 16)),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Salvar os dados
                            },
                            child:
                                Text('Salvar', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// Função para criar os TextField com o estilo desejado
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
        maxLines: maxLines,
      ),
    );
  }
}
