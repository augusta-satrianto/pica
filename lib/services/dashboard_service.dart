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
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data =
            DashboardModel.fromJson(jsonDecode(response.body)['data']);
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
