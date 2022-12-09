import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EntradaEventoProvider {
  final apiURL = 'http://10.0.2.2:8000/api';

  Future<LinkedHashMap<String, dynamic>> agregar(
      int evento_id, int entrada_id, String correo) async {
    var respuesta = await http.post(
      Uri.parse(apiURL + '/entradaEvento'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'correo': correo,
        'evento_id': evento_id,
        'entrada_id': entrada_id
      }),
    );
    return json.decode(respuesta.body);
  }
}
