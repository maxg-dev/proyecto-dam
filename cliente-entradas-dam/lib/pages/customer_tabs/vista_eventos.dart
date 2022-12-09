import 'package:cliente_entradas/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../services/entrada_evento_provider.dart';
import '../../services/entradas_provider.dart';
import '../../services/eventos_provider.dart';

class VistaEventos extends StatefulWidget {
  const VistaEventos({super.key});

  @override
  State<VistaEventos> createState() => _VistaEventosState();
}

class _VistaEventosState extends State<VistaEventos> {
  var fnumber =
      NumberFormat.currency(locale: 'es-CL', decimalDigits: 0, symbol: '');
  var fFecha = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EventosProvider().getEventosEstado(),
      builder: (context, AsyncSnapshot snapshotEvento) {
        if (!snapshotEvento.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(kColorPrimario),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView.separated(
              itemBuilder: (context, index) {
                var evento = snapshotEvento.data[index];
                return listTileEvento(
                  evento['id'],
                  evento['nombre'],
                  evento['fecha'],
                  evento['direccion'],
                  evento['precio'],
                  evento['estado'],
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshotEvento.data.length),
        );
      },
    );
  }

  ListTile listTileEvento(id, nombre, fecha, direccion, precio, estado) {
    return ListTile(
      leading: Icon(
        MdiIcons.ticket,
        color: Color(kColorPrimario),
      ),
      title: Text(
        nombre,
        style: TextStyle(color: Color(kColorPrimario)),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${direccion} - ${fFecha.format(DateTime.parse(fecha))}',
            style: TextStyle(color: Color(kColorSecundario)),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Precio: \$ ${fnumber.format(precio)}',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(kColorPrimario)),
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(kColorBoton))),
        onPressed: () async {
          var tengo = false;
          var evento = await EventosProvider().get(id);
          var mail = FirebaseAuth.instance.currentUser!.email!;

          if (evento['entradas'] != List.empty()) {
            for (var i = 0; i < evento['entradas'].length; i++) {
              if (mail == evento['entradas'][i]['pivot']['correo']) {
                tengo = true;
              }
            }
          }
          if (!tengo) {
            // generar entrada
            var entrada = await EntradasProvider().agregar();

            // generar venta
            var entradaEvento = await EntradaEventoProvider()
                .agregar(evento['id'], entrada['id'], mail);
            return showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Compra exitosa!'),
                  content: Text('Usted ha comprado una entrada al evento'),
                  actions: [
                    TextButton(
                      child: Text('Aceptar'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                );
              },
            );
          } else {
            return showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error!'),
                  content: Text('Usted ya compró una entrada al evento'),
                  actions: [
                    TextButton(
                      child: Text('Aceptar'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                );
              },
            );
          }
        },
        child: Icon(
          MdiIcons.cartCheck,
          color: Color(kColorFondo),
        ),
      ),
    );
  }
}
