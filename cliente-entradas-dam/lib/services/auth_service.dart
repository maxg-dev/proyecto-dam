import 'package:cliente_entradas/pages/admin_page.dart';
import 'package:cliente_entradas/pages/customer_page.dart';
import 'package:cliente_entradas/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.email.toString() == "admin@gmail.com") {
              return AdminPage();
            } else {
              return CustomerPage();
            }
          } else {
            return LoginPage();
          }
        });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signOutGoogle() async {
    FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }
}
