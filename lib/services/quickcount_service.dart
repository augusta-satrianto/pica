import 'package:http/http.dart' as http;
import 'package:pica/constan.dart';
import 'package:pica/models/api_response_model.dart';
import 'package:pica/services/auth_service.dart';

Future<ApiResponse> postQuickCount({
  required String rtrw,
  required String tps,
  required List paslonId,
  required List paslonSuara,
  required List<String> fotos,
}) async {
  print(fotos);
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();
  String kelurahanCode = await getKelurahanCode();
  var boundary = '------${DateTime.now().millisecondsSinceEpoch}------';
  var headers = {
    'Accept': 'multipart/form-data; boundary=$boundary',
    'X-Requested-With': 'XMLHttpRequest',
    'Authorization': 'Bearer $token'
  };
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseURL/store_quick_count'));
  request.fields.addAll({
    // 'rtrw': rtrw, //String
    'tps': tps, //String
    'kelurahan_code': kelurahanCode, //String
  });

  for (int i = 0; i < paslonId.length; i++) {
    request.fields['paslon_id[$i]'] = paslonId[i];
    request.fields['jumlah_suara[$i]'] = paslonSuara[i];
  }

  for (int i = 0; i < fotos.length; i++) {
    request.files.add(await http.MultipartFile.fromPath('fotos[$i]', fotos[i]));
  }

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    return apiResponse;
  } else {
    apiResponse.error = 'Terjadi Kesalahan';
    return apiResponse;
  }
}
