import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static final ApiHelper apiHelper = ApiHelper._();

  String api =
      'https://instagram28.p.rapidapi.com/media_info_v2?short_code=CA_ifcxMjFR';

  Future<List> getFeed() async {
    List allData = [];

    http.Response response = await http.get(
      Uri.parse(api),
      headers: {
        'X-RapidAPI-Key': '62c97cb3b9msh5b09e8ad38d418bp1703ccjsn959a9f8ebb8e',
        'X-RapidAPI-Host': 'instagram28.p.rapidapi.com'
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      allData = data['items'][0]['usertags']['in'];
    }
    return allData;
  }
}
