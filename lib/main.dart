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
              if (_usernameController.text == '1234' &&
                  _passwordController.text == '1234') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              } else {
                _showMessage(context, 'Nombre de usuario o contraseña incorrectos');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: Text('Iniciar sesión', style: TextStyle(color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
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

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<String> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chats = prefs.getStringList('chats') ?? [];
    });
  }

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
                // Llama al método estático _createChat de esta clase
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),

              ),
              child: const Text(
                'Menú de solicitudes',
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
                _showCreateChatDialog(context);
                // Llama al método estático _createChat de esta clase
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
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_chats[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteChat(_chats[index]);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(groupName: _chats[index])),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateChatDialog(BuildContext context) {
    final TextEditingController _groupNameController = TextEditingController();
    final TextEditingController _participantController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear nuevo grupo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del grupo',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _participantController,
                decoration: InputDecoration(
                  labelText: 'Cantidad de personas',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _createChat(_groupNameController.text, int.tryParse(_participantController.text) ?? 0);
                Navigator.of(context).pop();
              },
              child: Text('Crear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _createChat(String groupName, int participants) async {
    if (groupName.isNotEmpty && participants > 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _chats.add(groupName);
        prefs.setStringList('chats', _chats);
      });
    }
  }

  void _deleteChat(String groupName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chats.remove(groupName);
      prefs.remove(groupName);
      prefs.setStringList('chats', _chats);
    });
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
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _messages = prefs.getStringList(widget.groupName) ?? [];
    });
  }

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
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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

  void _sendMessage(String message) async {
    setState(() {
      _messages.add(message);
      _messageController.clear();
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.groupName, _messages);
    }
}