import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pica/constan.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/valid_invalid_model.dart';
import 'package:pica/services/auth_service.dart';

Future<ApiResponse> getVerifikasi(
    {required String jenis, required String status}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int id = await getUserId();
    print('$baseURL/mobile/$jenis?user_id=$id&status_validasi=$status');
    final response = await http.get(
        Uri.parse('$baseURL/mobile/$jenis?user_id=$id&status_validasi=$status'),
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': 'Bearer $token'
        });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data'][0]
            .map((p) => VerifikasiModel.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
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
