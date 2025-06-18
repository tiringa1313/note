import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para localização de datas

import 'package:note_gm/views/menu_principal_view.dart'; // Import do MenuPrincipal
import 'package:sqflite/sqflite.dart' as sqflite; // Para o uso do SQLite
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'dart:io'; // Para detectar a plataforma

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // carrega o .env

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // Inicialize o SQFlite FFI para suporte desktop
    sqflite_ffi.sqfliteFfiInit();
    sqflite.databaseFactory = sqflite_ffi.databaseFactoryFfi;
  }

  // Inicialize os dados de localização (por exemplo, para datas no formato local)
  await initializeDateFormatting();

  // Certifique-se de que todas as operações assíncronas acima terminem antes de iniciar o app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Aplicação',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Defina o tema da aplicação
      ),
      home: MenuPrincipalView(), // Atualizado para abrir o MenuPrincipal
      debugShowCheckedModeBanner: false, // Para remover a faixa de "debug"
    );
  }
}
