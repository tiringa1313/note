import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:note_gm/models/ia_service.dart';
import '../../models/boletim.dart';
import '../../models/database_helper.dart';

//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

class BoletimView extends StatefulWidget {
  final String viatura;
  final String nomenclatura;

  BoletimView({required this.viatura, required this.nomenclatura});

  @override
  _BoletimViewState createState() => _BoletimViewState();
}

class _BoletimViewState extends State<BoletimView> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController instrucoesController = TextEditingController();

  final IAService iaService = IAService(); // Instancia o IAService

  @override
  void initState() {
    super.initState();

    String viatura = widget.viatura.isNotEmpty ? widget.viatura : "Sem Viatura";
    String nomenclatura = widget.nomenclatura.isNotEmpty
        ? widget.nomenclatura
        : "Sem Nomenclatura";

    DateTime dataAtual = DateTime.now();
    int horas = dataAtual.hour;
    int minutos = dataAtual.minute;
    String dia = DateFormat('dd', 'pt_BR').format(dataAtual);
    String mesEAno = DateFormat('MMMM yyyy', 'pt_BR').format(dataAtual);
    String dataFormatada = '$dia de $mesEAno';

    String descricao =
        "Por volta das $horas horas e $minutos minutos do dia $dataFormatada, a guarnição da viatura $viatura - $nomenclatura,";

    descricaoController.text = descricao;
  }

  Future<void> corrigirTextoComIA(
      BuildContext context, String instrucoes) async {
    try {
      String descricao = descricaoController.text;
      // Chama o método corrigirTexto da IAService
      String textoCorrigido =
          await iaService.corrigirTexto(descricao, instrucoes);

      // Atualiza o campo de descrição com o texto corrigido
      descricaoController.text = textoCorrigido;

      // Exibe um SnackBar com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Texto corrigido com sucesso!')),
      );
    } catch (e) {
      // Exibe um SnackBar com erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao corrigir o texto: $e')),
      );
    }
  }

  Future<void> _exibirDialogo(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Corrigir Texto com IA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextField(
                controller: instrucoesController,
                decoration: InputDecoration(
                  hintText: 'Por favor, descreva as instruções...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String instrucoes = instrucoesController.text;
                Navigator.of(context).pop();
                await corrigirTextoComIA(context,
                    instrucoes); // Chama a função para corrigir o texto
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Boletim'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título do Atendimento'),
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 20),
            Text(
              'Descrição',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descricaoController,
                  maxLines: 14,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _exibirDialogo(context); // Exibe o diálogo de correção
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lightbulb_outline),
                    SizedBox(width: 8.0),
                    Text(
                      'Corrigir com IA',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: descricaoController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Boletim copiado para a área de transferência')),
                    );
                  },
                  icon: Icon(Icons.content_copy),
                  label: Text('Copiar Boletim'),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    String titulo = tituloController.text;
                    String descricao = descricaoController.text;

                    Boletim boletim = Boletim.create(
                      data: DateTime.now(),
                      tituloAtendimento: titulo,
                      descricao: descricao,
                    );

                    await DatabaseHelper().insertBoletim(boletim);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Boletim salvo com sucesso!')),
                    );

                    Navigator.pop(context, true);
                  },
                  icon: Icon(Icons.save),
                  label: Text('Salvar Boletim'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
