import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:pica/models/api_response_model.dart';
import 'package:pica/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constan.dart';

Future<ApiResponse> login(
    {required String email, required String password}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse('$baseURL/login'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    }, body: {
      'identity': email,
      'password': password
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            AuthModel.fromJson(jsonDecode(response.body)['data']);
        break;
      default:
        apiResponse.error = 'Silakan periksa kembali email dan password Anda';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Periksa koneksi internet anda';
  }
  return apiResponse;
}

//get token
Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? '';
}

//get role
Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('role') ?? '';
}

//get name
Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('name') ?? '';
}

// get emailogin
Future<String> getEmailLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('emaillogin') ?? '';
}

// get passwordlogin
Future<String> getPasswordLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('passwordlogin') ?? '';
}

//logout
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.remove('token');
}
