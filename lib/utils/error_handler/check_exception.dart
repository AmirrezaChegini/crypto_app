import 'package:crypto_app/utils/error_handler/app_exception.dart';
import 'package:dio/dio.dart';

class CheckException {
  static dynamic response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestEx(message: response.statusMessage);
      case 401:
        throw NotAuthEx(message: response.statusMessage);
      case 403:
        throw ForbiddexnEx(message: response.statusMessage);
      case 404:
        throw NotFoundEx(message: response.statusMessage);
      case 405:
        throw NotMethodAllowEx(message: response.statusMessage);
      case 500:
        throw ServerEx(message: response.statusMessage);
      default:
        throw FetchDataEx(message: response.statusMessage);
    }
  }
}
