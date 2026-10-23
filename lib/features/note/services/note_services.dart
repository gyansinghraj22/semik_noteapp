import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:noteapp/constants/api_url.dart';
import 'package:noteapp/core/common/error_model/error_model.dart';
import 'package:noteapp/core/network/dio_client.dart';

class NoteService {
  final DioClient dioClient;
  NoteService({required this.dioClient});

  Future<Either<dynamic, ErrorModel>> getNotes() async {
    try {
      var response = await dioClient.getData(ApiUrl.getNote);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return left(response);
      } else {
        return right(
          ErrorModel(
            code: response.statusCode,
            message: response.data['message'],
          ),
        );
      }
    } catch (e) {
      return right(ErrorModel(code: 400, message: "Failed to fetch notes"));
    }
  }

  Future<Either<dynamic, ErrorModel>> updateNote({
    required Map<String, dynamic> formData,
  }) async {
    try {
      var response = await dioClient.putData(ApiUrl.updateNote, formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return left(response);
      } else {
        return right(
          ErrorModel(
            code: response.statusCode,
            message: response.data['message'],
          ),
        );
      }
    } catch (e) {
      return right(ErrorModel(code: 400, message: "Failed to fetch notes"));
    }
  }

  Future<Either<dynamic, ErrorModel>> deleteNote({
    required Map<String, String> formData,
  }) async {
    try {
      var response = await dioClient.deleteData(ApiUrl.deleteNote);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return left(response);
      } else {
        return right(
          ErrorModel(
            code: response.statusCode,
            message: response.data['message'],
          ),
        );
      }
    } catch (e) {
      return right(ErrorModel(code: 400, message: "Failed to fetch notes"));
    }
  }

   Future<Either<dynamic, ErrorModel>> getNoteById({
    required Map<String, String> formData,
  }) async {
    try {
      var response = await dioClient.getData(ApiUrl.updateNote);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return left(response);
      } else {
        return right(
          ErrorModel(
            code: response.statusCode,
            message: response.data['message'],
          ),
        );
      }
    } catch (e) {
      return right(ErrorModel(code: 400, message: "Failed to fetch notes"));
    }
  }
}
