import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EventosProvider {
  final apiURL = 'http://10.0.2.2:8000/api';

  Future<LinkedHashMap<String, dynamic>> agregar(
      String nombre, String fecha, String direccion, int precio) async {
    var respuesta = await http.post(
      Uri.parse(apiURL + '/eventos'),
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'fecha': fecha,
        'direccion': direccion,
        'precio': precio,
        'estado': 1,
      }),
    );
    return json.decode(respuesta.body);
  }

  Future<List<dynamic>> getEventos() async {
    var respuesta = await http.get(Uri.parse(apiURL + '/eventos'));
    return respuesta.statusCode == 200 ? json.decode(respuesta.body) : [];
  }

  Future<List<dynamic>> getEventosEstado() async {
    var respuesta = await http.get(Uri.parse(apiURL + '/estado'));
    return respuesta.statusCode == 200 ? json.decode(respuesta.body) : [];
  }

  Future<LinkedHashMap<String, dynamic>> cambiarEstado(int id, String nombre,
      String fecha, String direccion, int precio, int estado) async {
    var respuesta = await http.put(
        Uri.parse(apiURL + '/eventos/' + id.toString()),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': nombre,
          'fecha': fecha,
          'direccion': direccion,
          'precio': precio,
          'estado': estado
        }));
    return json.decode(respuesta.body);
  }

  Future<LinkedHashMap<String, dynamic>> update(int id, String nombre,
      String fecha, String direccion, int precio, int estado) async {
    var respuesta = await http.put(
        Uri.parse(apiURL + '/eventos/' + id.toString()),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': nombre,
          'fecha': fecha,
          'direccion': direccion,
          'precio': precio,
          'estado': estado
        }));
    return json.decode(respuesta.body);
  }

  Future<LinkedHashMap<String, dynamic>> get(int id) async {
    var respuesta =
        await http.get(Uri.parse(apiURL + '/eventos/' + id.toString()));

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      return LinkedHashMap();
    }
  }

  Future<bool> borrar(int id) async {
    var respuesta =
        await http.delete(Uri.parse(apiURL + '/eventos/' + id.toString()));
    return respuesta.statusCode == 200;
  }
}
