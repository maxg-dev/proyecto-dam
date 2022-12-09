import 'package:cliente_entradas/constants.dart';
import 'package:cliente_entradas/services/entradas_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetalleEntradaPage extends StatelessWidget {
  final int numeroEntrada;
  const DetalleEntradaPage(this.numeroEntrada, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kColorFondo),
      appBar: AppBar(
          title: Text(
            'Detalle entrada',
            style: TextStyle(color: Color(kColorFondo)),
          ),
          backgroundColor: Color(kColorPrimario)),
      body: FutureBuilder(
          future: EntradasProvider().get(this.numeroEntrada),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var fFecha = DateFormat('dd-MM-yyyy');
            var fnumber = NumberFormat.currency(
                locale: 'es-CL', decimalDigits: 0, symbol: '');

            var entrada = snapshot.data;

            var titulo = entrada['eventos'][0]['nombre'];
            var direccion = entrada['eventos'][0]['direccion'];
            var fecha =
                fFecha.format(DateTime.parse(entrada['eventos'][0]['fecha']));
            var numeroEntrada = entrada['id'].toString().padLeft(7, '0');
            var precio = fnumber.format(entrada['eventos'][0]['precio']);
            var cliente = FirebaseAuth.instance.currentUser!.displayName!;
            var estado =
                entrada['eventos'][0]['estado'] == 1 ? 'Vigente' : 'Finalizado';
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 40, left: 15, bottom: 15, right: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text('Evento: ', style: kEstiloDetalle),
                            Text(titulo, style: kEstiloDato)
                          ]),
                          Row(children: [
                            Text('Dirección: ', style: kEstiloDetalle),
                            Text(direccion, style: kEstiloDato)
                          ]),
                          Row(children: [
                            Text('Fecha del evento: ', style: kEstiloDetalle),
                            Text(fecha, style: kEstiloDato)
                          ]),
                          Row(children: [
                            Text('Estado del evento: ', style: kEstiloDetalle),
                            Text(estado, style: kEstiloDato)
                          ]),
                        ]),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text('Numero de entrada: ', style: kEstiloDetalle),
                            Text('#${numeroEntrada}', style: kEstiloDato)
                          ]),
                          Row(children: [
                            Text('Valor entrada: ', style: kEstiloDetalle),
                            Text('\$ ${precio}', style: kEstiloDato)
                          ]),
                          Row(children: [
                            Text('Cliente: ', style: kEstiloDetalle),
                            Text(cliente, style: kEstiloDato)
                          ]),
                        ]),
                  ),
                  QrImage(
                    eyeStyle: QrEyeStyle(
                        color: Color(kColorPrimario),
                        eyeShape: QrEyeShape.square),
                    backgroundColor: Color(kColorFondo),
                    dataModuleStyle:
                        QrDataModuleStyle(color: Color(kColorPrimario)),
                    data: 'http://www.usmentradas.cl/${this.numeroEntrada}',
                    version: QrVersions.auto,
                    size: 200,
                  ),
                  Text('Escanear para más información', style: kEstiloDetalle),
                ],
              ),
            );
          }),
    );
  }
}
