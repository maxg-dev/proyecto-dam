import 'package:cliente_entradas/constants.dart';
import 'package:cliente_entradas/services/eventos_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgregarEventoPage extends StatefulWidget {
  const AgregarEventoPage({super.key});

  @override
  State<AgregarEventoPage> createState() => _AgregarEventoPageState();
}

class _AgregarEventoPageState extends State<AgregarEventoPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  DateTime fechaSeleccionada = DateTime.now();
  var fFecha = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kColorFondo),
      appBar: AppBar(
        backgroundColor: Color(kColorPrimario),
        title:
            Text('Agregar evento', style: TextStyle(color: Color(kColorFondo))),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            TextFormField(
              controller: nombreController,
              keyboardType: TextInputType.text,
              maxLength: 50,
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Indique nombre del evento';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Nombre del evento',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            Divider(color: Color(kColorFondo)),
            TextFormField(
              controller: direccionController,
              keyboardType: TextInputType.text,
              maxLength: 100,
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Indique direccion del evento';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Dirección del evento',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            Divider(color: Color(kColorFondo)),
            TextFormField(
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Indique precio de la entrada';
                }
                if (int.parse(valor) < 0) {
                  return 'Ingrese precio válido';
                }
                return null;
              },
              maxLength: 7,
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Precio entrada',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            Divider(color: Color(kColorFondo)),
            Row(
              children: [
                Text(
                  'Fecha del evento: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  fFecha.format(fechaSeleccionada),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(kColorPrimario)),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    MdiIcons.calendar,
                    color: Color(kColorPrimario),
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                      locale: Locale('es', 'ES'),
                    ).then((fecha) {
                      setState(() {
                        fechaSeleccionada = fecha ?? fechaSeleccionada;
                      });
                    });
                  },
                ),
              ],
            ),
            Divider(color: Color(kColorFondo)),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(Color(kColorFondo)),
                    backgroundColor:
                        MaterialStatePropertyAll(Color(kColorBoton))),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    //form ok
                    String nombre = nombreController.text.trim();
                    String direccion = direccionController.text.trim();
                    int precio = int.parse(precioController.text.trim());
                    String fecha = fechaSeleccionada.toString();

                    var respuesta = await EventosProvider()
                        .agregar(nombre, fecha, direccion, precio);

                    if (respuesta['message'] != null) {
                      var errores = respuesta['errors'];
                      setState(() {});
                      return;
                    }

                    Navigator.pop(context);
                  }

                  // data
                },
                child: Text('Agregar'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
