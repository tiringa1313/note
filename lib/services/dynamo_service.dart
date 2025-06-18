import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_gm/models/pessoa.dart';

class DynamoService {
  late final DynamoDB _dynamoDb;

  DynamoService() {
    final accessKey = dotenv.env['AWS_ACCESS_KEY']!;
    final secretKey = dotenv.env['AWS_SECRET_KEY']!;
    final region = dotenv.env['AWS_REGION'] ?? 'sa-east-1';

    final credentials = AwsClientCredentials(
      accessKey: accessKey,
      secretKey: secretKey,
    );

    _dynamoDb = DynamoDB(
      region: region,
      credentials: credentials,
    );
  }

  Future<void> salvarPessoa(PessoaModel pessoa) async {
    try {
      await _dynamoDb.putItem(
        tableName: 'pessoas',
        item: pessoa
            .toJson()
            .map((key, value) => MapEntry(key, AttributeValue(s: value))),
      );
      print('✅ Pessoa salva com sucesso no DynamoDB: ${pessoa.faceId}');
    } catch (e) {
      print('❌ Erro ao salvar no DynamoDB: $e');
    }
  }

  Future<PessoaModel?> buscarPessoaPorFaceId(String faceId) async {
    final response = await _dynamoDb.getItem(
      tableName: 'pessoas',
      key: {
        'faceId': AttributeValue(s: faceId),
      },
    );

    final item = response.item;

    if (item != null) {
      final dados = item.map(
        (key, value) => MapEntry(key, value.s ?? ''),
      );
      return PessoaModel.fromJson(dados);
    } else {
      return null;
    }
  }

  Future<PessoaModel?> getPessoaPorFaceId(String faceId) async {
    final response = await _dynamoDb.getItem(
      tableName: 'pessoas',
      key: {
        'faceId': AttributeValue(s: faceId),
      },
    );

    final item = response.item;
    if (item == null || item.isEmpty) {
      print('🛑 Pessoa não encontrada no DynamoDB com faceId: $faceId');
      return null;
    }

    // Converte o map do Dynamo para seu model
    final pessoaMap = <String, dynamic>{};
    item.forEach((key, value) => pessoaMap[key] = value.s ?? '');

    print('✅ Pessoa encontrada no DynamoDB: $pessoaMap');

    return PessoaModel.fromMap(pessoaMap);
  }
}
