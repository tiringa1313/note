import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/boletim.dart';

import 'package:flutter/services.dart';

class BoletimDetailView extends StatelessWidget {
  final Boletim boletim;

  BoletimDetailView({required this.boletim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Boletim'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boletim.tituloAtendimento,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Data: ${_formatDate(boletim.data)}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Descrição:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: boletim.descricao));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Descrição copiada para a área de transferência')),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              boletim.descricao,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'pt_BR').format(date);
  }
}
