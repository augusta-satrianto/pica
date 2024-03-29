import 'dart:convert';
import 'dart:io';
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
        if (jsonDecode(response.body)['data']['role'][0] == 'relawan') {
          apiResponse.data =
              AuthModel.fromJson(jsonDecode(response.body)['data']);
        } else {
          apiResponse.error = somethingWhentWrong;
        }
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

//get token
Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? '';
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

//get email
Future<String> getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('email') ?? '';
}

//get role
Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('role') ?? '';
}

//get user id
Future<int> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('userId') ?? 0;
}

Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('name') ?? '';
}

//logout
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.remove('token');
}

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}