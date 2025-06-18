import 'package:flutter/material.dart';

class MenuController {
  void navegarParaOutraTela(BuildContext context, String rota) {
    Navigator.pushNamed(context, rota);
  }
}
