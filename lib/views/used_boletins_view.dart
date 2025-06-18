import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/boletim.dart';
import '../models/database_helper.dart';

class UsedBoletinsView extends StatefulWidget {
  @override
  _UsedBoletinsViewState createState() => _UsedBoletinsViewState();
}

class _UsedBoletinsViewState extends State<UsedBoletinsView> {
  List<Boletim> usedBoletins = [];

  @override
  void initState() {
    super.initState();
    _loadUsedBoletins();
  }

  Future<void> _loadUsedBoletins() async {
    usedBoletins =
        await DatabaseHelper().getUsedBoletins(); // Ajuste conforme sua lógica
    setState(() {});
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Texto copiado para a área de transferência!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletins Utilizados'),
      ),
      body: ListView.builder(
        itemCount: usedBoletins.length,
        itemBuilder: (context, index) {
          Boletim boletim = usedBoletins[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(boletim.tituloAtendimento),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatDate(boletim.data)),
                  SizedBox(height: 4.0),
                  Text(boletim.descricao),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => _copyToClipboard(boletim.descricao),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
  }
}
