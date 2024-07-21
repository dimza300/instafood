import 'package:Instafood/helpers/GlobalConst.dart';
import 'package:Instafood/model/Item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Itemservices {
  final globData = Globalconst();
  final url = Globalconst.baseUrlApi;

  Future<ResponseItemModel> getItem() async {
    final token = await globData.getTokenStorage();
    final response = await http.get(
      Uri.parse('$url/api/get/item'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ResponseItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed fetch data");
    }
  }
}
