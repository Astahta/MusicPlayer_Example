import 'package:dio/dio.dart';
import 'package:music_player_example/widgets/utils.dart';

import '../constants.dart';

class ApiBaseHelper {
  static final String url = BaseString.baseUrl;
  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
            onRequest: (RequestOptions options) => requestInterceptor(options),
            onError: (DioError e) async {
              return e.response.data;
            }),
      );
  }

  static dynamic requestInterceptor(RequestOptions options) async {
    return options;
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  Future<Response?> getHTTP(String url) async {
    try {
      Response response = await baseAPI.get(url);
      return response;
    } on DioError catch(e) {
      // Handle error
      print(e);
      _errorHandler(e.error);
      return null;
    }
  }

  Future<Response?> postHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.post(url, data: data);
      return response;
    } on DioError catch(e) {
      // Handle error
      _errorHandler(e.error);
      return null;
    }
  }

  Future<Response?> putHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI.put(url, data: data);
      return response;
    } on DioError catch(e) {
      // Handle error
      print(e);
      _errorHandler(e.error);
      return null;
    }
  }

  Future<Response?> deleteHTTP(String url) async {
    try {
      Response response = await baseAPI.delete(url);
      return response;
    } on DioError catch(e) {
      // Handle error
      print(e);
      _errorHandler(e.error);
      return null;
    }
  }

  _errorHandler(dynamic e){
    if(e["message"] is String) {
      if(e["message"]!=null){
        Utils.displayToast("gagal, karena: " + e['message'].toString(), "warning");
      }
    } else {
      if(e["message"]!=null){
        Utils.displayToast(e['message'].toString(), "warning");
      } else {
        Utils.displayToast("Server sedang bermasalah", "warning");
      }

    }
  }
}
