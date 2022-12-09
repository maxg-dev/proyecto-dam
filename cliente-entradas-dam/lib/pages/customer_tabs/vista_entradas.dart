import 'package:cliente_entradas/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../services/entradas_provider.dart';
import '../detalle_entrada_page.dart';

class VistaEntradas extends StatefulWidget {
  const VistaEntradas({super.key});

  @override
  State<VistaEntradas> createState() => _VistaEntradasState();
}

class _VistaEntradasState extends State<VistaEntradas> {
  var fFecha = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EntradasProvider().getEntradas(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(kColorPrimario),
            ),
          );
        }

        List<dynamic> entradas = List<dynamic>.empty(growable: true);

        for (var i = 0; i < snapshot.data.length; i++) {
          if (snapshot.data[i]['eventos'] != null &&
              snapshot.data[i]['eventos'].length != 0) {
            if (snapshot.data[i]['eventos'][0]['pivot']['correo'] ==
                FirebaseAuth.instance.currentUser!.email!) {
              entradas.add(snapshot.data[i]);
            }
          }
        }

        return ListView.separated(
            itemBuilder: (context, index) {
              var entradaData = entradas[index];
              return listTileEntrada(
                  entradaData['id'],
                  entradaData['eventos'][0]['nombre'],
                  entradaData['eventos'][0]['fecha'],
                  entradaData['eventos'][0]['direccion']);
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: entradas.length);
      },
    );
  }

  ListTile listTileEntrada(numero, nombre, fecha, direccion) {
    return ListTile(
      title: Text(nombre, style: TextStyle(color: Color(kColorPrimario))),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${direccion} - ${fFecha.format(DateTime.parse(fecha))}',
            style: TextStyle(color: Color(kColorSecundario)),
          ),
        ],
      ),
      leading: Icon(MdiIcons.ticketConfirmation, color: Color(kColorPrimario)),
      trailing: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(kColorBoton)),
            foregroundColor: MaterialStatePropertyAll(Color(kColorFondo))),
        onPressed: () {
          // Ver detalle de una entrada
          MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => DetalleEntradaPage(numero));
          Navigator.push(context, route);
        },
        child: Icon(MdiIcons.contain),
      ),
    );
  }
}
