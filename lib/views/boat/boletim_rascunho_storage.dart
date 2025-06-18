import 'dart:convert';
import 'package:note_gm/views/boat/boletim_acidente_rascunho.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import condutor_placa_veiculo.dart; // se for separada

class BoletimRascunhoStorage {
  static const String _key = 'boletim_rascunho';

  /// Salva o rascunho localmente
  static Future<void> salvarRascunho(BoletimDeAcidenteRascunho rascunho) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(rascunho.toJson());
    await prefs.setString(_key, jsonStr);
  }

  /// Carrega o rascunho salvo
  static Future<BoletimDeAcidenteRascunho?> carregarRascunho() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);

    if (jsonStr == null) return null;

    try {
      final jsonMap = jsonDecode(jsonStr);
      return BoletimDeAcidenteRascunho.fromJson(jsonMap);
    } catch (e) {
      print('Erro ao carregar rascunho: $e');
      return null;
    }
  }

  /// Limpa o rascunho salvo
  static Future<void> limparRascunho() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
