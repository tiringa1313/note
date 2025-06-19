import 'package:flutter/material.dart';

Future<bool> showConfirmarEnvioImagemDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Análise'),
          content: const Text(
            'Deseja realmente enviar esta imagem para análise facial?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2A2F4F),
              ),
              child: const Text('Enviar'),
            ),
          ],
        ),
      ) ??
      false;
}
