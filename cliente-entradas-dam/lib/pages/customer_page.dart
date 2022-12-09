import 'package:cliente_entradas/constants.dart';
import 'package:cliente_entradas/pages/customer_tabs/vista_entradas.dart';
import 'package:cliente_entradas/pages/customer_tabs/vista_eventos.dart';
import 'package:cliente_entradas/pages/customer_tabs/vista_noticias.dart';
import 'package:cliente_entradas/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  int index = 0;
  final List<dynamic> paginas = [
    VistaNoticias(),
    VistaEventos(),
    VistaEntradas(),
  ];
  var fnumber =
      NumberFormat.currency(locale: 'es-CL', decimalDigits: 0, symbol: '');
  var fFecha = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kColorFondo),
      appBar: AppBar(
        backgroundColor: Color(kColorPrimario),
        leading: Align(
          alignment: Alignment.bottomCenter,
          child: AspectRatio(
            aspectRatio: 11 / 15,
            child: ProfilePicture(
              name: 'UserPP',
              radius: 31,
              fontsize: 30,
              img: FirebaseAuth.instance.currentUser!.photoURL,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              "Hola! ",
              style: TextStyle(color: Color(kColorFondo)),
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(color: Color(kColorTernario)),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(MdiIcons.logout, color: Color(kColorFondo)),
            color: Color(kColorFondo),
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 10,
                value: 'logout',
                child: Text('Cerrar Sesión'),
              ),
            ],
            onSelected: (opcionSeleccionada) {
              if (opcionSeleccionada == 'logout') {
                AuthService().signOutGoogle();
              }
            },
          ),
        ],
      ),
      body: paginas[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        fixedColor: Color(kColorPrimario),
        unselectedItemColor: Color(kColorFondo),
        onTap: (value) => setState(() {
          index = value; // hacer lista para control de tabs
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.newspaper),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.billboard),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.ticket),
            label: 'Entradas',
          )
        ],
      ),
    );
  }
}
