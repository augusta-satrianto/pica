import 'package:http/http.dart' as http;
import 'package:pica/constan.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/services/auth_service.dart';

Future<ApiResponse> verifikasiDdc(
    {required String nkk,
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
      http.MultipartRequest('POST', Uri.parse('$baseURL/ddc/verifikasi'));
  request.fields.addAll({
    'nkk': nkk,
    'keterangan': keterangan,
    'latitude': latitude,
    'longitude': longitude,
  });
  request.files.add(await http.MultipartFile.fromPath('foto', foto));

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    return apiResponse;
  } else {
    apiResponse.error = 'Terjadi Kesalahan';
    return apiResponse;
  }
}
