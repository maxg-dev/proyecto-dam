import 'package:cliente_entradas/constants.dart';
import 'package:cliente_entradas/pages/agregar_evento_page.dart';
import 'package:cliente_entradas/pages/editar_evento_page.dart';
import 'package:cliente_entradas/services/auth_service.dart';
import 'package:cliente_entradas/services/eventos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../services/firestore_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var fnumber =
      NumberFormat.currency(locale: 'es-CL', decimalDigits: 0, symbol: '');
  var fFecha = DateFormat('dd-MM-yyyy');
  final formKey = GlobalKey<FormState>();
  TextEditingController tituloController = TextEditingController();
  TextEditingController cuerpoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Color(kColorFondo),
          appBar: AppBar(
            backgroundColor: Color(kColorPrimario),
            leading: Icon(
              Icons.add_moderator,
              color: Color(kColorFondo),
            ),
            title: Text(
              'Administrador',
              style: TextStyle(color: Color(kColorFondo)),
            ),
            actions: [
              PopupMenuButton(
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
                    AuthService().signOut();
                  }
                },
              ),
            ],
            bottom: TabBar(tabs: [
              Tab(icon: Icon(MdiIcons.billboard), text: 'Eventos'),
              Tab(icon: Icon(MdiIcons.publish), text: 'Publicar noticia'),
            ]),
          ),
          body: TabBarView(
            children: [
              vistaListaEventos(),
              vistaPublicarNoticia(),
            ],
          )),
    );
  }

  Padding vistaPublicarNoticia() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Ingrese titulo de la noticia';
                }
              },
              maxLength: 50,
              controller: tituloController,
              decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            Divider(),
            TextFormField(
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Ingrese cuerpo de la noticia';
                }
              },
              maxLength: 200,
              maxLines: 5,
              controller: cuerpoController,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Cuerpo',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
            Divider(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(Color(kColorFondo)),
                    backgroundColor:
                        MaterialStatePropertyAll(Color(kColorBoton))),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    FirestoreService().agregar(
                      tituloController.text.trim(),
                      cuerpoController.text.trim(),
                    );
                    setState(() {
                      tituloController.text = '';
                      cuerpoController.text = '';
                    });
                  }
                },
                child: Text('Publicar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column vistaListaEventos() {
    return Column(
      children: [
        FutureBuilder(
          future: EventosProvider().getEventos(),
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
            return Expanded(
              child: Scrollbar(
                thickness: 5,
                radius: Radius.circular(30),
                trackVisibility: true,
                thumbVisibility: true,
                child: ListView.separated(
                  padding: EdgeInsets.all(15),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var evento = snapshot.data[index];
                    return listTileEvento(
                        context,
                        evento['id'],
                        evento['nombre'],
                        evento['direccion'],
                        evento['fecha'],
                        evento['entradas_vendidas'],
                        evento['precio'],
                        evento['estado']);
                  },
                ),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.all(15),
          alignment: AlignmentDirectional.bottomEnd,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Color(kColorBoton))),
              onPressed: (() {
                MaterialPageRoute route = new MaterialPageRoute(
                  builder: (context) => AgregarEventoPage(),
                );
                Navigator.push(context, route).then(
                  (value) => setState(() {}),
                );
              }),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.add),
                  Text(' Agregar nuevo evento'),
                ],
              )),
        )
      ],
    );
  }

  Slidable listTileEvento(
      padrecontext, id, titulo, direccion, fecha, vendidas, precio, estado) {
    estado = estado == 0 ? false : true;
    return Slidable(
      startActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Color(kColorTernario),
            onPressed: (context) async {
              var evento = await EventosProvider().get(id);
              if (evento['estado'] == 1 && evento['entradas_vendidas'] != 0) {
                return showDialog(
                  barrierDismissible: false,
                  context: padrecontext,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error!'),
                      content: Text(
                          'No puede eliminar un evento vigente con entradas compradas'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Aceptar')),
                      ],
                    );
                  },
                );
              } else {
                return showDialog(
                  barrierDismissible: false,
                  context: padrecontext,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Eliminar'),
                      content: Text('¿Desea eliminar ${evento['nombre']}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Aceptar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancelar'),
                        )
                      ],
                    );
                  },
                ).then((value) async {
                  if (value) {
                    await EventosProvider().borrar(id);
                    setState(() {});
                  }
                });
              }
            },
            icon: MdiIcons.delete,
            label: 'Borrar',
          ),
          SlidableAction(
            backgroundColor: Color(kColorSecundario),
            onPressed: (context) {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => EditarEventoPage(id),
              );
              Navigator.push(context, route).then(
                (value) => setState(() {}),
              );
            },
            icon: Icons.add,
            label: 'Editar',
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          MdiIcons.ticket,
          color: Color(kColorPrimario),
        ),
        title: Text(
          titulo,
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
                  padding: EdgeInsets.only(left: 1, top: 5),
                  child: Text(
                    'Entradas vendidas: ${vendidas}',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(kColorPrimario)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
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
        trailing: Switch(
          activeColor: Color(kColorPrimario),
          inactiveThumbColor: Color(kColorFondo),
          value: estado,
          onChanged: (value) async {
            await EventosProvider().cambiarEstado(
                id, titulo, fecha, direccion, precio, value == true ? 1 : 0);

            setState(() => estado = value);
          },
        ),
      ),
    );
  }
}
