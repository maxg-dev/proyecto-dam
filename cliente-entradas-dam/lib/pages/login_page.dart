import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cliente_entradas/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = '';
  String emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(kColorFondo),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entradas y Eventos',
                style: TextStyle(color: Color(kColorFondo)),
              ),
              Text(
                'Desarrolo de aplicaciones móviles',
                style: TextStyle(fontSize: 10, color: Color(kColorSecundario)),
              )
            ],
          ),
          leading: Icon(MdiIcons.ticketConfirmation, color: Color(kColorFondo)),
          backgroundColor: Color(kColorPrimario),
        ),
        body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Inicio de sesión',
                    style: TextStyle(
                        fontSize: 40,
                        color: Color(kColorPrimario),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo';
                    }
                    if (!RegExp(emailRegex).hasMatch(value)) {
                      return 'Formato de email no válido';
                    }
                    return null;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Correo',
                      icon: Icon(Icons.email, color: Color(kColorPrimario)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña';
                    }
                    return null;
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    icon: Icon(Icons.vpn_key, color: Color(kColorPrimario)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      child: Text('Iniciar sesión'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Color(kColorFondo)),
                          backgroundColor:
                              MaterialStatePropertyAll(Color(kColorBoton))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        child: Icon(MdiIcons.google),
                        onPressed: () => signInWithGoogle(),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Color(kColorFondo)),
                          backgroundColor:
                              MaterialStatePropertyAll(Color(kColorPrimario)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void pushPage(BuildContext context, Widget page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.push(context, route);
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('userEmail', userCredential.user!.email.toString());
    } on FirebaseAuthException catch (ex) {
      switch (ex.code) {
        case 'user-not-found':
          error = 'Credenciales incorrectas';
          break;
        case 'wrong-password':
          error = 'Credenciales incorrectas';
          break;
        case 'user-disabled':
          error = 'Cuenta desactivada';
          break;
        default:
          error = ex.message.toString();
          break;
      }
      setState(() {});
    }
  }
}
