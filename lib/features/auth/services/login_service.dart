import 'package:dartz/dartz.dart';
import 'package:noteapp/constants/api_url.dart';
import 'package:noteapp/core/common/error_model/error_model.dart';
import 'package:noteapp/core/network/dio_client.dart';

class LoginService {
  final DioClient dioClient;
  LoginService(this.dioClient);

  Future<Either<dynamic, ErrorModel>> login({
    required Map<String, dynamic> formData,
  }) async {
    var response = await dioClient.postData(ApiUrl.login, formData);
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // await SharedPref
        return left(response.data);
      } else {
        return right(
          ErrorModel(
            code: response.statusCode,
            message: response.statusMessage,
          ),
        );
      }
    } catch (e) {
      return right(ErrorModel(code: 400, message: "Login Failed"));
    }
  }
}
