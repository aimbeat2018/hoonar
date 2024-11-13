import 'dart:io';
import 'package:dio/dio.dart';

class UploadKycDocumentRequestModel {
  String? documentName; // Face,ID Proof,Address Proof
  File? document; // Assuming 'document' is a file to be uploaded

  UploadKycDocumentRequestModel({this.documentName, this.document});

  UploadKycDocumentRequestModel.fromJson(Map<String, dynamic> json) {
    documentName = json['document_name'];
    document = File(json['document']); // Convert path to File
  }

  Future<FormData> toFormData() async {
    Map<String, dynamic> fields = {
      'document_name': documentName,
    };

    // Attach the document as MultipartFile if it exists
    if (document != null) {
      fields['document'] = await MultipartFile.fromFile(
        document!.path,
        filename: document!.path.split('/').last, // Extract filename
      );
    }

    return FormData.fromMap(fields);
  }
}
