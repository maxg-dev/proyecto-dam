import 'package:cliente_entradas/constants.dart';
import 'package:cliente_entradas/services/eventos_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditarEventoPage extends StatefulWidget {
  final id;
  const EditarEventoPage(this.id, {super.key});

  @override
  State<EditarEventoPage> createState() => _EditarEventoPageState();
}

class _EditarEventoPageState extends State<EditarEventoPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  DateTime fechaSeleccionada = DateTime(2000);
  var fFecha = DateFormat('dd-MM-yyyy');
  var estado = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(kColorFondo),
        appBar: AppBar(
          backgroundColor: Color(kColorPrimario),
          title: Text('Editar evento',
              style: TextStyle(color: Color(kColorFondo))),
        ),
        body: FutureBuilder(
            future: EventosProvider().get(widget.id),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child:
                        CircularProgressIndicator(color: Color(kColorPrimario)),
                  ),
                );
              }

              var evento = snapshot.data;

              nombreController.text = nombreController.text.isEmpty
                  ? evento['nombre']
                  : nombreController.text;

              fechaSeleccionada = DateTime(2000) == fechaSeleccionada
                  ? DateTime.parse(evento['fecha'])
                  : fechaSeleccionada;

              direccionController.text = direccionController.text.isEmpty
                  ? evento['direccion']
                  : direccionController.text;

              precioController.text = precioController.text.isEmpty
                  ? evento['precio'].toString()
                  : precioController.text;

              estado = evento['estado'];

              return Form(
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
                      },
                      decoration: InputDecoration(
                          labelText: 'Nombre del evento',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                    Divider(color: Color(kColorFondo)),
                    TextFormField(
                      maxLength: 100,
                      controller: direccionController,
                      keyboardType: TextInputType.text,
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Indique dirección del evento';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Dirección del evento',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                    Divider(color: Color(kColorFondo)),
                    TextFormField(
                      maxLength: 7,
                      controller: precioController,
                      keyboardType: TextInputType.number,
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Indique precio de la entrada';
                        }
                        if (int.parse(valor) < 1) {
                          return 'Ingrese precio mayor a 0';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Precio entrada',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
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
                              print(fecha);
                              fechaSeleccionada = fecha ?? fechaSeleccionada;
                              setState(() {});
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
                            // data
                            String nombre = nombreController.text.trim();
                            String direccion = direccionController.text.trim();
                            int precio =
                                int.parse(precioController.text.trim());
                            String fecha = fechaSeleccionada.toString();

                            var respuesta = await EventosProvider().update(
                                widget.id,
                                nombre,
                                fecha,
                                direccion,
                                precio,
                                estado);

                            if (respuesta['message'] != null) {
                              print(respuesta);
                              var errores = respuesta['errors'];
                              setState(() {});
                              return;
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: Text('Editar'),
                      ),
                    ),
                  ]),
                ),
              );
            }));
  }
}
