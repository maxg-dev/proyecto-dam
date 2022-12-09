import 'package:cliente_entradas/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';

class VistaNoticias extends StatefulWidget {
  const VistaNoticias({super.key});

  @override
  State<VistaNoticias> createState() => _VistaNoticiasState();
}

class _VistaNoticiasState extends State<VistaNoticias> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreService().noticias(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var noticias = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListTile(
                leading: Icon(
                  Icons.newspaper,
                  color: Color(kColorPrimario),
                ),
                title: Text(
                  noticias['titulo'],
                  style: TextStyle(color: Color(kColorPrimario)),
                ),
                subtitle: Text(
                  noticias['cuerpo'],
                  style: TextStyle(color: Color(kColorSecundario)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
