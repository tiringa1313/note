import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/agente_info_rascunho.dart'; // ajuste o caminho se necessário

class AgenteRascunhoService {
  static const _keyAgenteInfo = 'agente_info';

  /// Salva as informações do agente no SharedPreferences
  static Future<void> salvarAgenteInfo(AgenteInfoRascunho agenteInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(agenteInfo.toJson());
    await prefs.setString(_keyAgenteInfo, jsonString);
  }

  /// Carrega as informações do agente do SharedPreferences
  static Future<AgenteInfoRascunho?> carregarAgenteInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyAgenteInfo);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return AgenteInfoRascunho.fromJson(data);
    } catch (e) {
      // Caso o JSON esteja corrompido
      print('Erro ao carregar agente_info: $e');
      return null;
    }
  }

  /// Remove as informações salvas do agente
  static Future<void> limparAgenteInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAgenteInfo);
  }
}
