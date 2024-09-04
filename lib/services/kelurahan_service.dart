import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pica/constan.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/kelurahan_model.dart';
import 'package:pica/services/auth_service.dart';

Future<ApiResponse> getKelurahan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    String kecamatanCode = await getKecamatanCode();
    print(kecamatanCode);
    final response = await http
        .get(Uri.parse('$baseURL/kelurahan/$kecamatanCode'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['kelurahan'][0]);
        apiResponse.data =
            KelurahanModel.fromJson(jsonDecode(response.body)['kelurahan'][0]);
        apiResponse.data as KelurahanModel;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWhentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
