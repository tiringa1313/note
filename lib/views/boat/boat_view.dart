import 'package:flutter/material.dart';
import 'package:note_gm/models/ia_service.dart';
import 'package:note_gm/utils/gerador_boletim.dart';
import 'package:note_gm/views/boat/boletimPreviewScreen.dart';
import 'package:note_gm/views/boat/boletim_acidente_completo.dart';
import 'package:note_gm/views/boat/boletim_acidente_rascunho.dart';
import 'package:note_gm/views/boat/dialogs/dialog_sinalizacao.dart';
import 'package:note_gm/views/boat/dialogs/dialog_tipo_sinistro.dart';
import 'package:note_gm/views/boat/dialogs/dialogo_desfecho_agente.dart';
import 'package:note_gm/views/boat/dialogs/dialogo_endereco.dart';
import 'package:note_gm/views/boat/widgets/card_informacoes_gerais.dart';
import 'package:note_gm/views/boat/widgets/versao_agente_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dialogs/dialog_dados_envolvido.dart';
import 'dialogs/dialog_veiculo.dart';
import 'dialogs/dialog_bicicleta.dart';
import 'dialogs/dialog_versao.dart';
import 'dialogs/dialog_orientacao.dart';
import 'widgets/condutor_card.dart';

class BoatView extends StatefulWidget {
  @override
  _BoatViewState createState() => _BoatViewState();
}

class _BoatViewState extends State<BoatView> {
  List<Map<String, dynamic>> condutores = [
    {
      "nome": "Envolvido 1",
      "categoria": "Condutor",
      "versao": "",
      "veiculo": {
        "modelo": "",
        "placa": "",
        "cor": "",
        "danos": "",
        "tipo": ""
      },
      "rascunho": BoletimDeAcidenteRascunho(
        nomeCondutor: "Envolvido 1",
        categoriaCnh: "Condutor",
      )
    },
    {
      "nome": "Envolvido 2",
      "categoria": "Condutor",
      "versao": "",
      "veiculo": {
        "modelo": "",
        "placa": "",
        "cor": "",
        "danos": "",
        "tipo": ""
      },
      "rascunho": BoletimDeAcidenteRascunho(
        nomeCondutor: "Envolvido 2",
        categoriaCnh: "Condutor",
      )
    },
  ];

  final TextEditingController versaoAgenteController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  List<String> listaDeRuas = [];

  String tipoSinistroSelecionado = "";
  String? ruaSelecionada;
  String? cruzamentoSelecionada;
  String? numeroSelecionado;
  String? bairroSelecionado;
  String? referenciaSelecionada;
  List<String> sinalizacoesSelecionadas = [];
  bool isLoading = false;

// Guarda eventual texto preenchido em "Outros"
  String outrosDetalhesSinalizacao = "";

  final List<String> categorias = ['Condutor', 'Ciclista', 'Pedestre'];

  void abrirDialogCadastro(int index) {
    final rascunho = condutores[index]["rascunho"] as BoletimDeAcidenteRascunho;

    showDialog(
      context: context,
      builder: (_) => DialogDadosEnvolvido(
        rascunho: rascunho,
        onSalvar: (rascunhoAtualizado) {
          setState(() {
            condutores[index]["rascunho"] = rascunhoAtualizado;
          });
        },
        listaDeRuas: listaDeRuas, // 🔥 Passando a lista para o Dialog
      ),
    );
  }

  void abrirDialogCadastroVeiculo(int index) {
    showDialog(
      context: context,
      builder: (_) => DialogVeiculo(
        modeloInicial: condutores[index]["veiculo"]?["modelo"],
        placaInicial: condutores[index]["veiculo"]?["placa"],
        corInicial: condutores[index]["veiculo"]?["cor"],
        danosIniciais: condutores[index]["veiculo"]?["danos"],
        tipoInicial: condutores[index]["veiculo"]?["tipo"],
        onSalvar: (
            {required modelo,
            required placa,
            required cor,
            required danos,
            required tipo}) {
          setState(() {
            condutores[index]["veiculo"] = {
              "modelo": modelo,
              "placa": placa,
              "cor": cor,
              "danos": danos,
              "tipo": tipo,
            };
          });
        },
      ),
    );
  }

  void abrirDialogCadastroBicicleta(int index) {
    showDialog(
      context: context,
      builder: (_) => DialogBicicleta(
        modeloInicial: condutores[index]["bicicleta"]?["modelo"],
        quadroInicial: condutores[index]["bicicleta"]?["quadro"],
        corInicial: condutores[index]["bicicleta"]?["cor"],
        danosIniciais: condutores[index]["bicicleta"]?["danos"],
        onSalvar: (
            {required modelo, required quadro, required cor, required danos}) {
          setState(() {
            condutores[index]["bicicleta"] = {
              "modelo": modelo,
              "quadro": quadro,
              "cor": cor,
              "danos": danos,
            };
          });
        },
      ),
    );
  }

  void abrirDialogVersao(int index) {
    final rascunho = condutores[index]["rascunho"] as BoletimDeAcidenteRascunho;

    showDialog(
      context: context,
      builder: (_) => DialogVersao(
        versaoInicial: rascunho.versaoDoCondutor,
        onSalvar: (novaVersao) {
          setState(() {
            rascunho.versaoDoCondutor = novaVersao;
          });
        },
      ),
    );
  }

  void adicionarCondutor() {
    if (condutores.length < 4) {
      setState(() {
        int index = condutores.length + 1;
        condutores.add({
          "nome": "Envolvido $index",
          "categoria": "Condutor",
          "rascunho": BoletimDeAcidenteRascunho(
            nomeCondutor: "Envolvido $index",
            categoriaCnh: "Condutor",
          )
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("B.O.A.T")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CardInformacoesGerais(
                    onEditarEndereco: () {
                      showDialog(
                        context: context,
                        builder: (_) => DialogEnderecoAcidente(
                          ruaAtual: ruaSelecionada,
                          cruzamentoAtual: cruzamentoSelecionada,
                          numeroAtual: numeroSelecionado,
                          bairroAtual: bairroSelecionado,
                          referenciaAtual: referenciaSelecionada,
                          onSalvar: ({
                            required String rua,
                            String? cruzamento,
                            String? numero,
                            String? bairro,
                            String? referencia,
                          }) {
                            setState(() {
                              ruaSelecionada = rua;
                              cruzamentoSelecionada = cruzamento;
                              numeroSelecionado = numero;
                              bairroSelecionado = bairro;
                              referenciaSelecionada = referencia;

                              // 🔥 Atualizar a lista de ruas para o DialogOrientacao
                              listaDeRuas.clear();
                              listaDeRuas.add(ruaSelecionada!);
                              if (cruzamentoSelecionada != null &&
                                  cruzamentoSelecionada!.trim().isNotEmpty) {
                                listaDeRuas.add(cruzamentoSelecionada!.trim());
                              }

                              // 🔥 Atualizar também o local para a IA
                              if (cruzamentoSelecionada != null &&
                                  cruzamentoSelecionada!.trim().isNotEmpty) {
                                localController.text =
                                    "$rua com $cruzamentoSelecionada";
                              } else {
                                localController.text = rua;
                              }
                            });
                          },
                        ),
                      );
                    },

                    onEditarDesfecho: () {
                      showDialog(
                        context: context,
                        builder: (_) => DialogDesfechoAgente(
                          desfechoInicial: versaoAgenteController.text,
                          onSalvar: (novoDesfecho) {
                            setState(() {
                              versaoAgenteController.text = novoDesfecho;
                            });
                          },
                        ),
                      );
                    },

                    onEditarTipoSinistro: () {
                      showDialog(
                        context: context,
                        builder: (_) => DialogTipoSinistro(
                          tipoAtual: tipoSinistroSelecionado,
                          onSalvar: (novoTipo) {
                            setState(() {
                              tipoSinistroSelecionado = novoTipo;
                            });
                          },
                        ),
                      );
                    },
                    onEditarSinalizacao: () {
                      showDialog(
                        context: context,
                        builder: (_) => DialogSinalizacao(
                          sinalizacoesAtuais: sinalizacoesSelecionadas,
                          onSalvar: (novasSinalizacoes, outrosTexto) {
                            setState(() {
                              sinalizacoesSelecionadas = novasSinalizacoes;
                              outrosDetalhesSinalizacao = outrosTexto;
                            });
                          },
                        ),
                      );
                    },

                    // Aqui estão os novos parâmetros booleanos para mostrar o V verdinho:
                    enderecoPreenchido:
                        ruaSelecionada != null && ruaSelecionada!.isNotEmpty,
                    desfechoPreenchido: versaoAgenteController.text.isNotEmpty,
                    tipoSinistroPreenchido: tipoSinistroSelecionado.isNotEmpty,
                    sinalizacaoPreenchida: sinalizacoesSelecionadas.isNotEmpty,
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    condutores.length,
                    (index) => CondutorCard(
                      condutor: condutores[index],
                      index: index,
                      categorias: categorias,
                      onEditarPessoa: abrirDialogCadastro,
                      onEditarVeiculo: abrirDialogCadastroVeiculo,
                      onEditarBicicleta: abrirDialogCadastroBicicleta,
                      onEditarVersao: abrirDialogVersao,
                      onEditarSentido: (idx) {
                        showDialog(
                          context: context,
                          builder: (_) => DialogOrientacao(
                            sentidoInicial: (condutores[idx]["rascunho"]
                                    as BoletimDeAcidenteRascunho)
                                .sentidoDeslocamento,
                            ruaInicial: (condutores[idx]["rascunho"]
                                    as BoletimDeAcidenteRascunho)
                                .ruaSelecionada,
                            listaDeRuas: listaDeRuas,
                            onSalvar: (novoSentido, novaRuaSelecionada) {
                              final rascunho = condutores[idx]["rascunho"]
                                  as BoletimDeAcidenteRascunho;
                              setState(() {
                                rascunho.sentidoDeslocamento = novoSentido;
                                rascunho.ruaSelecionada = novaRuaSelecionada;

                                // 🔥 Gerar o texto automático da versão:
                                final nomeCondutor =
                                    rascunho.nomeCondutor ?? "O condutor";
                                final rua = novaRuaSelecionada;
                                final sentido = novoSentido;

                                rascunho.versaoDoCondutor =
                                    "$nomeCondutor trafegava pela $rua no sentido $sentido.";
                              });
                            },
                          ),
                        );
                      },
                      onChangeCategoria: (i, novaCategoria) {
                        setState(() {
                          condutores[i]["categoria"] = novaCategoria;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (condutores.length < 4)
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          size: 40, color: Colors.blue),
                      onPressed: adicionarCondutor,
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.receipt_long, size: 28),
                      label: Text(
                        isLoading
                            ? "Gerando Boletim..."
                            : "GERAR BOLETIM DE TRÂNSITO",
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                // 🔥 Pega viatura e equipe do SharedPreferences
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final viatura =
                                    prefs.getString('numero_viatura') ?? "078";
                                final equipe =
                                    prefs.getString('nome_viatura') ??
                                        "Trânsito";
                                final viaturaEquipe =
                                    "viatura $viatura - $equipe";

                                // 🔥 Gera a lista de envolvidos
                                final envolvidos = condutores.where((e) {
                                  final rascunho = e["rascunho"]
                                      as BoletimDeAcidenteRascunho;
                                  final veiculo =
                                      e["veiculo"] as Map<String, dynamic>?;

                                  final temRelato = rascunho.versaoDoCondutor
                                          ?.trim()
                                          .isNotEmpty ??
                                      false;
                                  final temPlaca = veiculo?["placa"]
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ??
                                      false;
                                  final temSentido = rascunho
                                          .sentidoDeslocamento
                                          ?.trim()
                                          .isNotEmpty ??
                                      false;

                                  return temRelato || temPlaca || temSentido;
                                }).map<Map<String, String>>((e) {
                                  final rascunho = e["rascunho"]
                                      as BoletimDeAcidenteRascunho;
                                  final veiculo =
                                      e["veiculo"] as Map<String, dynamic>?;

                                  final nomeCondutor =
                                      (rascunho.nomeCondutor?.trim() ?? "");
                                  final nome = (nomeCondutor.isNotEmpty &&
                                          !nomeCondutor
                                              .toLowerCase()
                                              .startsWith("envolvido"))
                                      ? nomeCondutor
                                      : "Condutor não identificado";
                                  final cnh = (rascunho.cnhCondutor
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? rascunho.cnhCondutor!.trim()
                                      : "não informado";

                                  final modeloVeiculo =
                                      (rascunho.modelo?.trim().isNotEmpty ??
                                              false)
                                          ? rascunho.modelo!.trim()
                                          : (veiculo?["modelo"]
                                                  ?.toString()
                                                  .trim() ??
                                              "Veículo");

                                  final corVeiculo =
                                      (rascunho.cor?.trim().isNotEmpty ?? false)
                                          ? rascunho.cor!.trim()
                                          : (veiculo?["cor"]
                                                  ?.toString()
                                                  .trim() ??
                                              "");

                                  final placa = (veiculo?["placa"]
                                              ?.toString()
                                              .trim()
                                              .isNotEmpty ??
                                          false)
                                      ? veiculo!["placa"]!.toString()
                                      : "sem placa de identificação";

                                  final sentido = (rascunho.sentidoDeslocamento
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? rascunho.sentidoDeslocamento!.trim()
                                      : "não informado";

                                  final versao = (rascunho.versaoDoCondutor
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                      ? rascunho.versaoDoCondutor!.trim()
                                      : "";

                                  return {
                                    "nome": nome,
                                    "cnh": cnh,
                                    "veiculo":
                                        "$modeloVeiculo ${corVeiculo}".trim(),
                                    "placa": placa,
                                    "sentido": sentido,
                                    "versao": versao,
                                  };
                                }).toList();

                                // 🔥 Gera data/hora atual
                                final now = DateTime.now();
                                final data =
                                    "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

                                String hora;
                                if (now.minute == 0) {
                                  hora = "${now.hour} horas";
                                } else {
                                  hora =
                                      "${now.hour} horas e ${now.minute.toString().padLeft(2, '0')} minutos";
                                }

                                // 🔥 Chama a IA para gerar o BOAT
                                final textoBoat = await IAService().gerarBoat(
                                  local: localController.text.isNotEmpty
                                      ? localController.text
                                      : "local não informado",
                                  data: data,
                                  hora: hora,
                                  viaturaEquipe: viaturaEquipe,
                                  tipoSinistro:
                                      tipoSinistroSelecionado.isNotEmpty
                                          ? tipoSinistroSelecionado
                                          : "acidente de trânsito",
                                  envolvidos: envolvidos,
                                  conclusao:
                                      "Não houve vítimas, a via foi liberada e os envolvidos foram orientados.",
                                );

                                // 🔥 Abre tela de visualização
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BoletimPreviewScreen(
                                      textoBoletim: textoBoat,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Erro ao gerar boletim: $e"),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
