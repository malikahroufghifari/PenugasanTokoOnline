import 'dart:convert';
import 'package:penugasan_tokoonline/models/product_model.dart';
import 'package:penugasan_tokoonline/models/response_data_list.dart';
import 'package:penugasan_tokoonline/models/user_login.dart';
import 'package:penugasan_tokoonline/services/url.dart' as url;
import 'package:http/http.dart' as http;

class ProductService {
  Future getBarang() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    var uri = Uri.parse("${url.BaseUrl}/admin/getbarang");
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    var getBarang = await http.get(uri, headers: headers);
    if (getBarang.statusCode == 200) {
      var data = json.decode(getBarang.body);
      if (data["status"] == true) {
        List product = data["data"].map((r) => ProductModel.fromJson(r)).toList();
        ResponseDataList response = ResponseDataList(
          status: true,
          message: 'success load data',
          data: product,
        );
        return response;
      } else {
        ResponseDataList response = ResponseDataList(
          status: false,
          message: 'Failed load data',
        );
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: "gagal load product dengan code error ${getBarang.statusCode}",
      );
      return response;
    }
  }
}
