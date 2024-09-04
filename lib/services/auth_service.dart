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
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
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

//get user id
Future<int> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('userId') ?? 0;
}

//get name
Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('name') ?? '';
}

//get name
Future<String> getFotoAtas() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('fotoAtas') ?? '';
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

//get user id
Future<int> getTeamId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('teamId') ?? 0;
}

//get kabupatenCode
Future<String> getKabupatenCode() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('kabupatenCode') ?? '';
}

//get kecamatanCode
Future<String> getKecamatanCode() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('kecamatanCode') ?? '';
}

//get kelurahanCode
Future<String> getKecamatanName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('kecamatanName') ?? '';
}

//get kelurahanCode
Future<String> getKelurahanCode() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('kelurahanCode') ?? '';
}

//get kelurahanCode
Future<String> getKelurahanName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('kelurahanName') ?? '';
}

//get kelurahanCode
Future<String> getColorHex() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('colorHex') ?? '';
}

//logout
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.remove('fotoAtas');
  return preferences.remove('token');
}
