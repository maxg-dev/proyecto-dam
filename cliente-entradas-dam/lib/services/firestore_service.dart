import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> noticias() {
    return FirebaseFirestore.instance.collection('noticias').snapshots();
  }

  Future agregar(String titulo, String cuerpo) {
    return FirebaseFirestore.instance
        .collection('noticias')
        .doc()
        .set({'titulo': titulo, 'cuerpo': cuerpo});
  }
}
