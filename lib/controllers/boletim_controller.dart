import '../models/database_helper.dart';
import '../models/boletim.dart';

class BoletimController {
  late final DatabaseHelper _databaseHelper;

  BoletimController() {
    _databaseHelper = DatabaseHelper();
    // Ao inicializar o controlador, carregue os boletins do banco de dados
    loadBoletins();
  }

  // Lista que armazena os boletins.
  List<Boletim> boletins = [];

  // Método para carregar os boletins do banco de dados
  Future<void> loadBoletins() async {
    try {
      // Carrega os boletins do banco de dados
      //List<Boletim> loadedBoletins = await _databaseHelper.get(); // Correção aqui para get()

      // Atribui os boletins carregados à lista boletins
      //boletins = loadedBoletins;
    } catch (e) {
      // Trate qualquer erro que possa ocorrer durante o carregamento
      print('Erro ao carregar os boletins: $e');
    }
  }

  // Método para adicionar um novo boletim à lista.
  void addBoletim(Boletim boletim) {
    // Adiciona o boletim à lista e realiza a persistência se necessário
    boletins.add(boletim);

    // Se quiser garantir que a adição também salve o boletim no banco, pode chamar um método do databaseHelper aqui.
    // _databaseHelper.insert(boletim);
  }

  // Método para buscar boletins com base em uma consulta.
  List<Boletim> searchBoletins(String query) {
    // Filtra os boletins com base na consulta fornecida.
    return boletins.where((boletim) {
      // Converte os títulos e descrições dos boletins e a consulta para minúsculas.
      final tituloLower = boletim.tituloAtendimento.toLowerCase();
      final descricaoLower = boletim.descricao.toLowerCase();
      final searchLower = query.toLowerCase();

      // Retorna verdadeiro se o título ou a descrição do boletim contiverem a consulta.
      return tituloLower.contains(searchLower) ||
          descricaoLower.contains(searchLower);
    }).toList(); // Converte o resultado para uma lista.
  }
}
