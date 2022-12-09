import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EntradasProvider {
  final apiURL = 'http://10.0.2.2:8000/api';

  Future<LinkedHashMap<String, dynamic>> agregar() async {
    var respuesta = await http.post(
      Uri.parse(apiURL + '/entradas'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{}),
    );
    return json.decode(respuesta.body);
  }

  Future<List<dynamic>> getEntradas() async {
    var respuesta = await http.get(Uri.parse(apiURL + '/entradas'));
    return respuesta.statusCode == 200 ? json.decode(respuesta.body) : [];
  }

  Future<LinkedHashMap<String, dynamic>> get(int id) async {
    var respuesta =
        await http.get(Uri.parse(apiURL + '/entradas/' + id.toString()));
    return respuesta.statusCode == 200 ? json.decode(respuesta.body) : [];
  }
}
