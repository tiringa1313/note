import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para manipulação da área de transferência
import 'package:note_gm/models/ia_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/database_helper.dart';

import 'package:flutter/services.dart';

import '../../models/equipe.dart'; // Para manipulação da área de transferência

class BoletimFiscalizacaoView extends StatefulWidget {
  @override
  _BoletimFiscalizacaoViewState createState() =>
      _BoletimFiscalizacaoViewState();
}

class _BoletimFiscalizacaoViewState extends State<BoletimFiscalizacaoView> {
  // Controladores de texto para os campos do formulário
  final TextEditingController _nomeCondutorController = TextEditingController();
  final TextEditingController _placaVeiculoController = TextEditingController();
  final TextEditingController _ruaAbordagemController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _motivoAbordagemController =
      TextEditingController();
  final TextEditingController _medidasTomadasController =
      TextEditingController();

  // Instância do DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _gerarBoletimIA() async {
    final nomeCondutor = _nomeCondutorController.text;
    final placaVeiculo = _placaVeiculoController.text;
    final ruaAbordagem = _ruaAbordagemController.text;
    final numero = _numeroController.text;
    final motivoAbordagem = _motivoAbordagemController.text;
    final medidasTomadas = _medidasTomadasController.text;

    // Verificar se todos os campos foram preenchidos
    if (nomeCondutor.isNotEmpty &&
        placaVeiculo.isNotEmpty &&
        ruaAbordagem.isNotEmpty &&
        numero.isNotEmpty &&
        motivoAbordagem.isNotEmpty &&
        medidasTomadas.isNotEmpty) {
      try {
        // Recupera as informações de viatura e nomenclatura das SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? viatura = prefs.getString('numero_viatura');
        String? nomenclatura = prefs.getString('nome_viatura');

        if (nomenclatura == null) {
          throw Exception(
              'Não há informações de viatura ou nomenclatura armazenadas');
        }

        // Função para obter o nome do mês por extenso
        String _mesPorExtenso(int mes) {
          const meses = [
            'janeiro',
            'fevereiro',
            'março',
            'abril',
            'maio',
            'junho',
            'julho',
            'agosto',
            'setembro',
            'outubro',
            'novembro',
            'dezembro'
          ];
          return meses[mes - 1]; // Retorna o mês correspondente ao número
        }

        final agora = DateTime.now();
        final horas = agora.hour
            .toString()
            .padLeft(2, '0'); // Formata a hora com 2 dígitos
        final minutos = agora.minute
            .toString()
            .padLeft(2, '0'); // Formata os minutos com 2 dígitos
        final dia =
            agora.day.toString().padLeft(2, '0'); // Formata o dia com 2 dígitos
        final mes = _mesPorExtenso(agora.month); // Obtém o mês por extenso
        final ano = agora.year;

// Data formatada com o dia, mês e ano
        final dataAtual = "$dia de $mes de $ano";

// Gerar o texto do boletim
        final boletim = '''
Por volta das $horas horas e $minutos minutos do dia $dataAtual, a guarnição da viatura $viatura - $nomenclatura,
realizava fiscalização de trânsito na rua $ruaAbordagem, número $numero,
quando verificou o veículo de placa $placaVeiculo, $motivoAbordagem.
Desta forma, a equipe realizou os seguintes procedimentos: $medidasTomadas.
''';

        // Agora corrigimos o boletim com a IA logo após a geração
        _corrigirBoletimComIA(boletim);
      } catch (e) {
        // Em caso de erro (exemplo: nenhuma viatura ou nomenclatura encontrada)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar boletim: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  // Função para exibir o boletim em um Dialog
  void _exibirDialogBoletim(String boletim) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Boletim Gerado'),
          content: SingleChildScrollView(
            child: Text(boletim),
          ),
          actions: <Widget>[
            // Botão para copiar para a área de transferência
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: boletim)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Boletim copiado para a área de transferência!')),
                  );
                  Navigator.of(context).pop(); // Fechar o Dialog
                });
              },
              child: Text('Copiar'),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _corrigirBoletimComIA(String boletimOriginal) async {
    // Definir as instruções de correção
    String instrucoesCorrecao = '''
1. Corrija a gramática e a pontuação do texto de forma que ele esteja correto e formal.
2. Verifique se o texto está claro, adequado para um boletim de fiscalização e consistente em termos de coesão e coerência.
3. Corrija qualquer erro de digitação ou frases mal estruturadas, garantindo que o texto tenha fluidez e clareza.
4. Reestruture frases quando necessário, especialmente quando o texto perder coesão, como por exemplo: "autuado e liberado" deve ser ajustado para "o condutor foi autuado e liberado".
5. Mantenha o conteúdo essencial, mas adicione mais detalhes ou reformule as frases para melhorar a compreensão e clareza do boletim.
6. Certifique-se de que todas as informações estão bem conectadas, sem contradições ou ambiguidades.
7. Verifique a fluidez do texto e faça ajustes para que o boletim tenha uma leitura natural e profissional.
''';

    try {
      // Usar a classe IAService para corrigir o boletim
      IAService iaService = IAService();
      String boletimCorrigido =
          await iaService.corrigirTexto(boletimOriginal, instrucoesCorrecao);

      // Exibir o boletim corrigido em um dialog
      _exibirDialogBoletim(boletimCorrigido);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao corrigir boletim com IA: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boletim de Fiscalização'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Nome do Condutor
              _buildTextField(
                controller: _nomeCondutorController,
                label: 'Nome do Condutor',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Placa do Veículo
              _buildTextField(
                controller: _placaVeiculoController,
                label: 'Placa do Veículo',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Rua da Abordagem
              _buildTextField(
                controller: _ruaAbordagemController,
                label: 'Rua da Abordagem',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Número
              _buildTextField(
                controller: _numeroController,
                label: 'Número',
                maxLines: 1,
              ),
              SizedBox(height: 16.0),

              // Campo Motivo da Abordagem
              _buildTextField(
                controller: _motivoAbordagemController,
                label: 'Motivo da Abordagem',
                maxLines: 3, // Permite mais linhas de texto
              ),
              SizedBox(height: 16.0),

              // Campo Medidas Tomadas
              _buildTextField(
                controller: _medidasTomadasController,
                label: 'Medidas Tomadas',
                maxLines: 3, // Permite mais linhas de texto
              ),
              SizedBox(height: 32.0),

              // Botão para gerar boletim
              Center(
                child: ElevatedButton(
                  onPressed: _gerarBoletimIA,
                  child: Text('Gerar Boletim'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Função que retorna um TextField estilizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required int maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.blueGrey.withOpacity(0.1), // Cor de fundo suave
      ),
      maxLines: maxLines,
      keyboardType: TextInputType.text,
    );
  }
}
