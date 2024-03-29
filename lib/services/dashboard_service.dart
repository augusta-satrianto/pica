import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pica/constan.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/dashboard_model.dart';
import 'package:pica/services/auth_service.dart';

Future<ApiResponse> getDashboard() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$baseURL/dashboard'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print('getDashboard: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data =
            DashboardModel.fromJson(jsonDecode(response.body)['data']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 500:
        print(response.body);
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

Future<ApiResponse> verifikasiMobile(
    {required String nik,
    required String noTelp,
    required String keterangan,
    required String latitude,
    required String longitude,
    required String foto}) async {
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();
  var boundary = '------${DateTime.now().millisecondsSinceEpoch}------';
  var headers = {
    'Accept': 'multipart/form-data; boundary=$boundary',
    'X-Requested-With': 'XMLHttpRequest',
    'Authorization': 'Bearer $token'
  };
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseURL/mobile/verifikasi'));
  request.fields.addAll({
    'nik': nik,
    'no_telp': noTelp,
    'keterangan': keterangan,
    'latitude': latitude,
    'longitude': longitude,
  });
  request.files.add(await http.MultipartFile.fromPath('foto', foto));

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  print('verif mobile : ${response.statusCode}');
  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> jsonResponse = json.decode(responseBody);
    // apiResponse.data = jsonResponse['data']['data']['id'].toString();
    return apiResponse;
  } else {
    String? somethingWentWrong;
    apiResponse.error = somethingWentWrong;
    return apiResponse;
  }
}
