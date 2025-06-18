import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_gm/models/database_helper.dart';
import 'package:note_gm/models/placa_veiculo.dart';
import 'package:flutter/services.dart'; // Para usar TextInputFormatter
import 'package:note_gm/views/dadosDoCondutorView.dart';
import 'package:note_gm/views/detalhes_placa_view.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Converter todo o texto inserido para maiúsculas
    String newText = newValue.text.toUpperCase();
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class PlacasVisadasView extends StatefulWidget {
  @override
  _PlacasVisadasViewState createState() => _PlacasVisadasViewState();
}

class _PlacasVisadasViewState extends State<PlacasVisadasView> {
  final TextEditingController _placaController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<PlacaVeiculo> _placas = [];
  bool _isPlacaNova = false; // Controle para saber se a placa é nova ou não

  // Variáveis para armazenar o caminho das fotos
  String _fotoPlacaPath = '';
  String _fotoChassiPath = '';
  String _fotoVeiculoPath = '';
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _anoController = TextEditingController();
  TextEditingController _chassiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPlacas(); // Carregar placas no início
  }

  // Função para buscar as placas cadastradas no banco de dados
  Future<void> _fetchPlacas() async {
    List<String> placasStrings = await _dbHelper.getPlacas();
    List<PlacaVeiculo> placasVeiculo = placasStrings.map((placa) {
      return PlacaVeiculo(
        placa: placa,
        marca: '',
        modelo: '',
        ano: '',
        chassi: '',
        fotoPath: '',
        fotoChassi: '',
        fotoVeiculo: '',
        dataCadastro: DateTime.now(),
      );
    }).toList();

    setState(() {
      _placas = placasVeiculo;
    });
  }

  // Função para verificar se a placa já está cadastrada
  Future<void> _verificarPlacaExistente(String placa) async {
    bool existe = await _dbHelper.existsPlaca(placa);
    setState(() {
      _isPlacaNova = !existe; // Se a placa não existe, ela é nova
    });
  }

  Future<void> _cadastrarPlaca(String placa) async {
    if (!(await _dbHelper.existsPlaca(placa))) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Exibindo o título com o número da placa
                      Text(
                        'Cadastrar a Placa: $placa', // Exibe a placa aqui
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      // Campo de Marca
                      TextField(
                        controller: _marcaController,
                        decoration: InputDecoration(
                          labelText: 'Marca',
                          prefixIcon:
                              Icon(Icons.car_repair), // Ícone para Marca
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de Modelo
                      TextField(
                        controller: _modeloController,
                        decoration: InputDecoration(
                          labelText: 'Modelo',
                          prefixIcon:
                              Icon(Icons.directions_car), // Ícone para Modelo
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de Ano
                      TextField(
                        controller: _anoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Ano',
                          prefixIcon:
                              Icon(Icons.calendar_today), // Ícone para Ano
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de Chassi (opcional)
                      TextField(
                        controller: _chassiController,
                        decoration: InputDecoration(
                          labelText: 'Chassi (opcional)',
                          prefixIcon:
                              Icon(Icons.card_travel), // Ícone para Chassi
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Campos para as fotos (Placa, Chassi e Veículo)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _fotoCard('Placa', _fotoPlacaPath, 'placa', setState),
                          _fotoCard(
                              'Chassi', _fotoChassiPath, 'chassi', setState),
                          _fotoCard(
                              'Veículo', _fotoVeiculoPath, 'veiculo', setState),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botão de cadastrar
                          TextButton(
                            onPressed: () async {
                              // Cria o objeto da placa com todos os dados
                              PlacaVeiculo novaPlaca = PlacaVeiculo(
                                placa: placa,
                                marca: _marcaController.text,
                                modelo: _modeloController.text,
                                ano: _anoController.text,
                                fotoPath: _fotoPlacaPath, // Foto de placa
                                fotoChassi: _fotoChassiPath, // Foto de chassi
                                fotoVeiculo:
                                    _fotoVeiculoPath, // Foto do veículo
                                chassi: _chassiController.text,
                                dataCadastro: DateTime.now(),
                              );

                              // Salva a placa no banco de dados
                              await _dbHelper.insertPlaca(novaPlaca);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Placa cadastrada com sucesso!')));

                              // Atualiza a lista de placas cadastradas
                              _fetchPlacas();

                              // Limpa os campos e fotos após o cadastro
                              _placaController.clear();
                              _marcaController.clear();
                              _modeloController.clear();
                              _anoController.clear();
                              _chassiController.clear();
                              setState(() {
                                _fotoPlacaPath = '';
                                _fotoChassiPath = '';
                                _fotoVeiculoPath = '';
                              });

                              // Fecha o Dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('Cadastrar'),
                          ),
                          // Botão de cancelar
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Fecha o Dialog sem realizar ação
                            },
                            child: Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Placa já cadastrada!')));
    }
  }

  // Função para exibir as fotos (ajustada)
  Widget _fotoCard(
      String nomeFoto, String fotoPath, String tipoFoto, Function setState) {
    return Column(
      children: [
        fotoPath.isEmpty
            ? GestureDetector(
                onTap: () async {
                  // Ao clicar, chama a função para tirar a foto e atualizar o estado
                  await _tirarFoto(tipoFoto);
                  setState(() {}); // Atualiza a UI após a foto ser tirada
                },
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.grey,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(fotoPath), // Exibe a foto capturada
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
        SizedBox(height: 8),
        Text(nomeFoto, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  // Função para tirar a foto
  Future<void> _tirarFoto(String tipoFoto) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        // Atualizando o caminho da foto com o caminho retornado
        if (tipoFoto == 'placa') {
          _fotoPlacaPath = pickedFile.path;
        } else if (tipoFoto == 'chassi') {
          _fotoChassiPath = pickedFile.path;
        } else if (tipoFoto == 'veiculo') {
          _fotoVeiculoPath = pickedFile.path;
        }
      });
    } else {
      print("Nenhuma foto foi tirada!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Placas Visadas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulário para entrada da placa
            TextFormField(
              controller: _placaController,
              decoration: InputDecoration(
                labelText: 'Informe a Placa',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              maxLength: 7,
              inputFormatters: [
                UpperCaseTextFormatter()
              ], // Adiciona o formatter
              onChanged: (placa) {
                _verificarPlacaExistente(placa.toUpperCase());
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe uma placa válida';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            // Se a placa for nova, mostra o botão para cadastrar
            _isPlacaNova
                ? ElevatedButton(
                    onPressed: () {
                      _cadastrarPlaca(_placaController.text.toUpperCase());
                    },
                    child: Text('Cadastrar Placa'),
                  )
                : Container(),
            SizedBox(height: 20),
            // Exibe a lista de placas cadastradas
            Expanded(
              child: ListView.builder(
                itemCount: _placas.length,
                itemBuilder: (context, index) {
                  PlacaVeiculo placaVeiculo = _placas[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        placaVeiculo.placa,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Data do cadastro: ${DateFormat('dd/MM/yyyy').format(placaVeiculo.dataCadastro)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.preview,
                            color: const Color.fromARGB(255, 23, 24, 24)),
                        onPressed: () {
                          // Aqui você pode adicionar a navegação para a view de detalhes
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalhesPlacaView(placaVeiculo: placaVeiculo),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
