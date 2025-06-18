import 'dart:io';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class S3Service {
  late final S3 _s3;
  final String _bucketName;
  final String _region;

  S3Service()
      : _bucketName = dotenv.env['AWS_BUCKET_NAME']!,
        _region = dotenv.env['AWS_REGION']!,
        _s3 = S3(
          region: dotenv.env['AWS_REGION']!,
          credentials: AwsClientCredentials(
            accessKey: dotenv.env['AWS_ACCESS_KEY']!,
            secretKey: dotenv.env['AWS_SECRET_KEY']!,
          ),
        );

  Future<String> uploadImage(File imageFile, String fileName) async {
    final imageBytes = await imageFile.readAsBytes();

    await _s3.putObject(
      bucket: _bucketName,
      key: fileName,
      body: imageBytes,
      contentType: 'image/jpeg',
      //acl: ObjectCannedACL.publicRead,
    );

    // ✅ Retorna a URL com base na região
    return 'https://$_bucketName.s3.$_region.amazonaws.com/$fileName';
  }
}
