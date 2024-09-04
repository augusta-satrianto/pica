import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pica/constan.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/paslon_model.dart';
import 'package:pica/services/auth_service.dart';

Future<ApiResponse> getPaslon() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    int teamId = await getTeamId();
    final response = await http.get(
        Uri.parse('$baseURL/paslon_quick_count?team_id=$teamId'),
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': 'Bearer $token'
        });
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data'][0]);
        apiResponse.data = jsonDecode(response.body)['data'][0]
            .map((p) => PaslonModel.fromJson(p))
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
