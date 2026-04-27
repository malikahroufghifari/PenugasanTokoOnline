import 'dart:convert';
import 'package:penugasan_tokoonline/models/product_model.dart';
import 'package:penugasan_tokoonline/models/response_data_list.dart';
import 'package:penugasan_tokoonline/models/response_data_map.dart';
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
        List product = data["data"]
            .map((r) => ProductModel.fromJson(r))
            .toList();
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

  Future insertBarang(request, image, id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login/token invalid',
      );
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer${user.token}',
      "Content-type": "multipart/form-data",
    };
    http.MultipartRequest response;
    if (id == null) {
      response = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/insertbarang"),
      );
    } else {
      response = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/updatebarang/$id"),
      );
    }
    if (image != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        image.path,
      );
      response.files.add(multipartFile);
    }
    response.headers.addAll(headers);
    response.fields['nama_barang'] = request['nama_barang'];
    response.fields['deskripsi'] = request['deskripsi'];
    response.fields['stok'] = request['stok'];
    response.fields['harga'] = request['harga'];

    var res = await response.send();
    var result = await http.Response.fromStream(res);

    if (res.statusCode == 200) {
      var data = json.decode(result.body);
      print(data);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: 'succes insert/update data',
        );
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: 'Failed insert/update data',
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: 'Gagal load barang dengan code error ${res.statusCode}',
      );
      return response;
    }
  }

  Future hapusBarang(context, id) async{
    UserLogin userLogin = UserLogin();
    var uri = Uri.parse(url.BaseUrl+"/admin/hapusbarang/$id");
    var user = await userLogin.getUserLogin();
    if(user.status == false){
      ResponseDataList response = ResponseDataList(status: false, message: 'anda belum login/token invalid');
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer${user.token}',
    };
    var hapusBarang = await http.delete(uri, headers: headers);
    if (hapusBarang.statusCode == 200){
      var result = json.decode(hapusBarang.body);
      if(result["status"] == true){
        ResponseDataList response = ResponseDataList(status: true, message: 'succes hapus data');
        return response;
      }else{
        ResponseDataList response = ResponseDataList(status: false, message: 'failed hapus data');
        return response;
      }
    }else{
      ResponseDataList response = ResponseDataList(status: false , message: 'gagal hapus barang dengan code error ${hapusBarang.statusCode}');
      return response;
    }
  }
}
