import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_gm/models/database_helper.dart';
import 'package:note_gm/models/observacoes.dart';

class ObservacoesView extends StatefulWidget {
  @override
  _ObservacoesViewState createState() => _ObservacoesViewState();
}

class _ObservacoesViewState extends State<ObservacoesView> {
  List<Observacao> observacoes = [];
  List<Observacao> observacoesFiltradas = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filtrarObservacoes);
    _carregarObservacoes();
  }

  Future<void> _carregarObservacoes() async {
    List<Observacao> lista = await DatabaseHelper().getObservacoes();
    setState(() {
      observacoes = lista;
      observacoesFiltradas = List.from(observacoes);
    });
  }

  void _filtrarObservacoes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      observacoesFiltradas = observacoes.where((obs) {
        return obs.tituloObservacao.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _excluirObservacao(int id) async {
    await DatabaseHelper().deleteObservacao(id);
    await _carregarObservacoes(); // Atualiza a lista após a exclusão
  }

  void _mostrarDialogoAdicionarObservacao() {
    TextEditingController _tituloController = TextEditingController();
    TextEditingController _observacaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    labelText: 'Qual a Infração?',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _observacaoController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Observação de Infração',
                    border: OutlineInputBorder(),
                    hintText: 'Digite a observação aqui...',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_tituloController.text.isNotEmpty &&
                            _observacaoController.text.isNotEmpty) {
                          Observacao novaObservacao = Observacao(
                            tituloObservacao: _tituloController.text,
                            descricao: _observacaoController.text,
                            dataCadastro: DateTime.now().toString(),
                          );

                          await DatabaseHelper()
                              .insertObservacao(novaObservacao);
                          await _carregarObservacoes();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Por favor, preencha todos os campos")),
                          );
                        }
                      },
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Observações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Observação',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: observacoesFiltradas.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma observação encontrada',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: observacoesFiltradas.length,
                      itemBuilder: (context, index) {
                        final obs = observacoesFiltradas[index];
                        return Card(
                          child: ListTile(
                            title: Text(obs.tituloObservacao),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: obs.descricao));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Observação copiada!')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _excluirObservacao(obs.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionarObservacao,
        child: Icon(Icons.add),
      ),
    );
  }
}
