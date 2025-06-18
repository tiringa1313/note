import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_gm/views/used_boletins_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boletins/boletim_detail_view.dart';
import 'boletins/boletim_view.dart';
import '../models/database_helper.dart';
import '../models/boletim.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Boletim> boletins = [];
  List<Boletim> _filteredBoletins = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBoletins();
  }

  Future<void> _loadBoletins() async {
    boletins = await DatabaseHelper().getBoletins();
    _filteredBoletins = List.from(boletins); // Initialize the filtered list
    print("Número de boletins carregados: ${boletins.length}");
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
  }

  void _searchBoletins() {
    setState(() {
      if (searchController.text.isEmpty) {
        _filteredBoletins = List.from(boletins);
      } else {
        _filteredBoletins = boletins.where((boletim) {
          return boletim.tituloAtendimento.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ||
              boletim.descricao.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  );
        }).toList();
      }
    });
  }

  void _excluirBoletim(String boletimId) async {
    try {
      // Exclui o boletim do banco de dados
      await DatabaseHelper().deleteBoletim(boletimId);

      // Atualiza a lista de boletins após a exclusão
      _loadBoletins();

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Boletim excluído com sucesso!')),
      );
    } catch (e) {
      // Exibe uma mensagem de erro se a exclusão falhar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir o boletim: $e')),
      );
    }
  }

  Future<Map<String, String>> _getViaturaData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? viatura = prefs.getString('numero_viatura');
    String? nomenclatura = prefs.getString('nome_viatura');

    // Retorna os dados da viatura como um mapa
    return {
      'viatura': viatura ?? '', // Se não encontrar, retorna uma string vazia
      'nomenclatura':
          nomenclatura ?? '', // Se não encontrar, retorna uma string vazia
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletins'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Apenas o campo de busca
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar Boletim',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search), // Ícone de lupa
                    ),
                    onChanged: (value) {
                      _searchBoletins();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBoletins.length,
              itemBuilder: (context, index) {
                Boletim boletim = _filteredBoletins[index];
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      title: Text(
                        boletim.tituloAtendimento,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(boletim.data),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoletimDetailView(
                              boletim: boletim,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _excluirBoletim(boletim.id);
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addBoletim',
            onPressed: () async {
              // Obter dados da viatura armazenados nas SharedPreferences
              Map<String, String> viaturaData = await _getViaturaData();

              // Passa os dados da viatura para a tela de BoletimView
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoletimView(
                    viatura: viaturaData['viatura'] ?? '',
                    nomenclatura: viaturaData['nomenclatura'] ?? '',
                  ),
                ),
              );

              // Se um boletim for salvo, recarrega a lista de boletins
              if (result == true) {
                _loadBoletins(); // Recarrega os boletins
              }
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
