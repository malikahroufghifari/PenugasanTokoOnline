import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:penugasan_tokoonline/models/response_data_list.dart';
import 'package:penugasan_tokoonline/models/response_data_map.dart';
import 'package:penugasan_tokoonline/models/user_login.dart';
import 'package:penugasan_tokoonline/services/url.dart' as url;


class Pesan {
  UserLogin userLogin = UserLogin();

  Future<ResponseDataMap> saveToDB(dataRequest) async {
  var uri = Uri.parse(url.BaseUrl + "/user/transaksi");
  var user = await userLogin.getUserLogin();

  Map<String, String> headers = {
    "Authorization": 'Bearer ${user.token}',
    "Content-Type": "application/json",
  };

  var response = await http.post(
    uri,
    headers: headers,
    body: json.encode(dataRequest),
  );

  var data = json.decode(response.body);

  if (response.statusCode == 200) {
    return ResponseDataMap(
      status: true,
      message: data["message"],
      data: data["data"],
    );
  } else {
    return ResponseDataMap(
      status: false,
      message: data["message"] ?? "Gagal",
    );
  }
}
  Future<ResponseDataList> getHistory() async {
    // Sesuai Postman: GET ke /user/transaksi
    var uri = Uri.parse(url.BaseUrl + "/user/history_trans");
    var user = await userLogin.getUserLogin();

    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      'Content-Type': "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);
      var data = json.decode(response.body);

      // Sesuai Postman: Jika status sukses
      if (response.statusCode == 200) {
        return ResponseDataList(
          status: true,
          message: "Berhasil memuat riwayat",
          // Mengambil isi key "data" yang berbentuk [] (List) di Postman
          data: data['data'], 
        );
      } else {
        return ResponseDataList(
          status: false, 
          message: data['message'] ?? "Gagal memuat riwayat"
        );
      }
    } catch (e) {
      return ResponseDataList(status: false, message: e.toString());
    }
  }
}