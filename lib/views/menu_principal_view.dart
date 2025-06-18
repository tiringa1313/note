import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_gm/views/boat/boat_view.dart';
import 'package:note_gm/views/boletins/boletim_fiscalizacao_view.dart';
import 'package:note_gm/views/home_view.dart'; // Import da HomeView

import 'package:flutter/material.dart';
import 'package:note_gm/views/observacoesInfracoes/observacoes_infracoes.dart';
import 'package:note_gm/views/pessoa/FaceRecognitionPage.dart';
import 'package:note_gm/views/placasVisadas/placas_visadas_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPrincipalView extends StatefulWidget {
  @override
  _MenuPrincipalViewState createState() => _MenuPrincipalViewState();
}

class _MenuPrincipalViewState extends State<MenuPrincipalView> {
  TextEditingController _numeroViaturaController = TextEditingController();
  TextEditingController _nomeViaturaController = TextEditingController();
  bool isNumeroViaturaFixed = false;
  bool isNomeViaturaFixed = false;

  @override
  void initState() {
    super.initState();
    _loadViatura();
  }

  // Carregar o número e nome da viatura salvos nas SharedPreferences
  Future<void> _loadViatura() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? numeroViatura = prefs.getString('numero_viatura');
    String? nomeViatura = prefs.getString('nome_viatura');

    if (numeroViatura != null) {
      _numeroViaturaController.text = numeroViatura;
      setState(() {
        isNumeroViaturaFixed = true;
      });
    }

    if (nomeViatura != null) {
      _nomeViaturaController.text = nomeViatura;
      setState(() {
        isNomeViaturaFixed = true;
      });
    }
  }

  // Salvar o número e nome da viatura nas SharedPreferences
  Future<void> _saveViatura() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('numero_viatura', _numeroViaturaController.text);
    await prefs.setString('nome_viatura', _nomeViaturaController.text);
  }

  // Função para alternar a "fixação" do número e nome da viatura
  void _toggleFixNumeroViatura() {
    setState(() {
      isNumeroViaturaFixed = !isNumeroViaturaFixed;
    });
    if (isNumeroViaturaFixed) {
      _saveViatura();
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('numero_viatura');
      });
    }
  }

  void _toggleFixNomeViatura() {
    setState(() {
      isNomeViaturaFixed = !isNomeViaturaFixed;
    });
    if (isNomeViaturaFixed) {
      _saveViatura();
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove('nome_viatura');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha com os dois campos de viatura
            Card(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Campo para Número da Viatura
                    Expanded(
                      flex: 1, // Flex para que o campo ocupe metade da linha
                      child: TextField(
                        controller: _numeroViaturaController,
                        decoration: InputDecoration(
                          labelText: 'Prefixo',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isNumeroViaturaFixed
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                            ),
                            onPressed: _toggleFixNumeroViatura,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0), // Espaço entre os campos
                    // Campo para Nome da Viatura
                    Expanded(
                      flex: 1, // Flex para que o campo ocupe metade da linha
                      child: TextField(
                        controller: _nomeViaturaController,
                        decoration: InputDecoration(
                          labelText: 'Viatura',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isNomeViaturaFixed
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                            ),
                            onPressed: _toggleFixNomeViatura,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Restante do conteúdo (por exemplo, os Cards do menu)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 colunas
                crossAxisSpacing: 10.0, // Espaço horizontal entre os cards
                mainAxisSpacing: 10.0, // Espaço vertical entre os cards
                children: <Widget>[
                  _buildCard(context, 'Boletins', Icons.assignment, HomeView()),
                  _buildCard(
                      context, 'Observações', Icons.traffic, ObservacoesView()),
                  _buildCard(context, 'Placas Visadas', Icons.motorcycle,
                      PlacasVisadasView()),
                  _buildCard(
                      context, 'Pessoas', Icons.people, FaceRecognitionPage()),
                  _buildCard(context, 'B.A Trânsito', Icons.warning,
                      BoletimFiscalizacaoView()),
                  _buildCard(context, 'BOAT', Icons.report, BoatView()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // criar o card function
  Widget _buildCard(
      BuildContext context, String title, IconData icon, Widget? destination) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 48),
              SizedBox(height: 16),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
