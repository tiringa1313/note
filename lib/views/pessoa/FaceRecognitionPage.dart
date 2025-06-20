import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_gm/models/pessoa.dart';
import 'package:note_gm/services/face_service.dart';
import 'package:note_gm/views/pessoa/DetalhesPessoaPage.dart';
import 'package:note_gm/views/pessoa/dialogs/confirmar_envio_imagem_dialog.dart';
import 'package:note_gm/views/pessoa/dialogs/pessoa_localizada_dialog.dart';
import 'package:note_gm/views/pessoa/cadastro_pessoa_page.dart';
import 'package:note_gm/views/pessoa/possiveis_correspondencias_view.dart';

class FaceRecognitionPage extends StatefulWidget {
  @override
  _FaceRecognitionPageState createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> {
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();
  bool shouldShowRegisterButton = false;
  bool isLoadingImage = false;

  Future<void> captureAndSendImage() async {
    setState(() => isLoadingImage = true);

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      setState(() => isLoadingImage = false);
      print("❌ Captura cancelada.");
      return;
    }

    final image = File(pickedFile.path);
    setState(() {
      _capturedImage = image;
      isLoadingImage = false;
    });

    final confirmar = await showConfirmarEnvioImagemDialog(context);
    if (!confirmar) {
      print('❌ Envio cancelado pelo usuário.');
      return;
    }

    try {
      final lista = await FaceService.buscarMultiplasCorrespondencias(image);

      if (lista.isNotEmpty) {
        final pessoaMaisProxima = PessoaModel.fromJson(lista[0]);
        final similaridade = pessoaMaisProxima.similaridade ?? 0.0;

        // Reconhecimento automático se similaridade for muito alta
        if (similaridade >= 0.9) {
          print("✅ Pessoa reconhecida com alta similaridade ($similaridade)");
          showDialog(
            context: context,
            builder: (_) => PessoaLocalizadaDialog(pessoa: pessoaMaisProxima),
          );
          setState(() => shouldShowRegisterButton = false);
          return;
        }

        // Caso não atinja 0.9, mostra lista de possíveis correspondências
        final resultado = await Navigator.push<PessoaModel>(
          context,
          MaterialPageRoute(
            builder: (_) => PossiveisCorrespondenciasView(
              correspondencias: lista,
              onCadastrarNovo: () => Navigator.pop(context),
            ),
          ),
        );

        if (resultado != null) {
          // Agente confirmou uma correspondência

          setState(() => shouldShowRegisterButton = false);
          return;
        }
      }

      // Nenhuma correspondência confirmada → habilita botão de cadastrar
      print("🔍 Nenhuma pessoa confirmada. Pode cadastrar.");
      setState(() => shouldShowRegisterButton = true);
    } catch (e) {
      print('⚠️ Erro ao buscar pessoa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao processar a imagem. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Stack(
        children: [
          // Ilustração fixa no canto inferior
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 8.0),
              child: Image.asset(
                'assets/illustrations/find.png',
                height: 180,
              ),
            ),
          ),

          // Conteúdo rolável acima da imagem
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (_capturedImage == null) {
                        await captureAndSendImage();
                      }
                    },
                    child: Container(
                      height: 240,
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: isLoadingImage
                          ? const Center(child: CircularProgressIndicator())
                          : _capturedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _capturedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/illustrations/reconhecimento-facial.png',
                                      height: 80,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Clique para detectar rosto',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botão principal
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (shouldShowRegisterButton) {
                          if (_capturedImage == null) return;
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CadastroPessoaPage(
                                onSalvar: (pessoa) async =>
                                    await FaceService.cadastrarPessoa(
                                        _capturedImage!, pessoa),
                              ),
                            ),
                          );
                          if (resultado == 'sucesso') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Cadastro realizado com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          await captureAndSendImage();
                        }
                      },
                      icon: Icon(
                        shouldShowRegisterButton
                            ? Icons.person_add
                            : Icons.search,
                        color: Colors.white,
                      ),
                      label: Text(
                        shouldShowRegisterButton
                            ? 'Cadastrar Indivíduo'
                            : 'Detectar Rosto',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2F4F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão secundário
                  ElevatedButton.icon(
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white, // Ícone branco
                      ),
                      label: const Text(
                        'Buscar na Galeria',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Texto branco
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.indigo[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        print('📸 Iniciando seleção de imagem da galeria...');
                        final pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery);

                        if (pickedFile == null) {
                          print('❌ Nenhuma imagem selecionada.');
                          return;
                        }

                        final image = File(pickedFile.path);
                        print('📁 Imagem selecionada: ${image.path}');

                        setState(() {
                          _capturedImage = image;
                        });
                        final confirmar =
                            await showConfirmarEnvioImagemDialog(context);
                        if (!confirmar) {
                          print('❌ Envio cancelado pelo usuário.');
                          return;
                        }

                        final lista =
                            await FaceService.buscarMultiplasCorrespondencias(
                                image);
                        if (lista.length == 1 &&
                            (lista[0]['similaridade'] ?? 0.0) >= 0.9) {
                          print(
                              '🎯 Similaridade alta. Pulando a tela de correspondências.');

                          final pessoa = PessoaModel.fromJson(lista[0]);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetalhesPessoaPage(pessoa: pessoa),
                            ),
                          );
                          return;
                        }

                        print('📋 Lista de correspondências retornada: $lista');

                        if (lista.isNotEmpty) {
                          print(
                              '✅ Correspondências encontradas. Navegando para tela de resultados...');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PossiveisCorrespondenciasView(
                                correspondencias: lista,
                                onCadastrarNovo: () {
                                  print(
                                      '➕ Usuário optou por cadastrar novo indivíduo.');
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CadastroPessoaPage(
                                        onSalvar: (pessoa) async {
                                          await FaceService.cadastrarPessoa(
                                              image, pessoa);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          print('🔴 Nenhuma correspondência encontrada!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Nenhuma correspondência encontrada.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }),
                  const SizedBox(
                      height: 140), // garante distância da imagem decorativa
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
