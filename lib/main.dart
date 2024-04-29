import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio de sesión',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,

      ),
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TutoUis'),
      ),
      body: Column(
        children: [
          // Agregar la imagen en la parte superior
          Image.asset(
            'assets/image.png',
            height: 300,// Ajusta la altura según tu necesidad
            width: 300, // Ocupa todo el ancho disponible
            fit: BoxFit.cover, // Ajusta la imagen para que cubra el contenedor
          ),
          LoginForm(),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Nombre de usuario',
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Verifica las credenciales
              if (_usernameController.text == '1234' &&
                  _passwordController.text == '1234') {
                // Si las credenciales son correctas, navega al menú
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              } else {
                // Muestra un mensaje de error
                _showMessage(context, 'Nombre de usuario o contraseña incorrectos');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Cambiar el color del botón a verde
            ),
            child: Text('Iniciar sesión',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menú'),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes agregar la lógica para crear grupos
                    // Por ahora, solo navegaremos de vuelta a la página de inicio de sesión
                    Navigator.pop(context);
                  },

                  child: Text('Crear grupo'),
                ),
              ],
            ),
            ),
        );
    }
}