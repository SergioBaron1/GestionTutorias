import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
        title: const Text('TutoUis'),
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de usuario',
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: const Text('Iniciar sesión',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                )
            ),
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
          title: const Text('Mensaje'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
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
        title: const Text('Menú'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Llama al método estático _createChat de esta clase
                _createChat(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),

              ),
              child: const Text(
                'Ver perfíl',
                style:  TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Llama al método estático _createChat de esta clase
                _createChat(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),

              ),
              child: const Text(
                'Crear grupo',
                style:  TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define el método estático _createChat que toma el contexto como argumento
  static void _createChat(BuildContext context) async {
    final TextEditingController _groupNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear grupo'),
          content: TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del grupo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_groupNameController.text.isNotEmpty) {
                  // Crear una instancia de chat con el nombre proporcionado
                  Chat newChat = Chat(name: _groupNameController.text);
                  // Guardar el chat en el almacenamiento
                  await _saveChat(newChat);
                  // Cerrar el cuadro de diálogo
                  Navigator.of(context).pop();
                  // Navegar a la pantalla de chat con el nuevo grupo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen(groupName: newChat.name)),
                  );
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  // Define el método _saveChat para guardar el chat en el almacenamiento
  static Future<void> _saveChat(Chat chat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chats = prefs.getStringList('chats') ?? [];
    chats.add(chat.name);
    await prefs.setStringList('chats', chats);
  }
}

class ChatScreen extends StatefulWidget {
  final String groupName;

  ChatScreen({required this.groupName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = []; // Lista de mensajes del chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    setState(() {
      _messages.add(message);
      _messageController.clear();
    });
    // Aquí puedes implementar la lógica para enviar el mensaje al backend o a otros usuarios
  }
}

class Chat {
  final String name;

  Chat({required this.name});
}
