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
  String _selectedRole = 'Estudiante'; // Default role is Student

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
          DropdownButtonFormField<String>(
            value: _selectedRole,
            onChanged: (newValue) {
              setState(() {
                _selectedRole = newValue!;
              });
            },
            items: ['Estudiante', 'Tutor'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Seleccione su rango',
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Obtenemos el nombre de usuario y la contraseña ingresados
              String username = _usernameController.text;
              String password = _passwordController.text;

              // Verificamos si el nombre de usuario y la contraseña son correctos
              if (username == '1234' && password == '1234') {
                // Si son correctos, navegamos a la página del menú
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              } else {
                // Si son incorrectos, mostramos un mensaje de error
                _showMessage(context, 'Nombre de usuario o contraseña incorrectos');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: Text(
              'Iniciar sesión',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedStudentCount = 1; // Default selected count
  String _selectedSubject = 'Calculo I'; // Default selected subject
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatNames = prefs.getStringList('chatNames');
    if (chatNames != null) {
      setState(() {
        _chats = chatNames.map((chatName) {
          List<String>? messages = prefs.getStringList(chatName);
          return Chat(chatName, messages ?? []);
        }).toList();
      });
    }
  }

  void _saveChat(Chat chat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatNames = prefs.getStringList('chatNames') ?? [];
    if (!chatNames.contains(chat.groupName)) {
      chatNames.add(chat.groupName);
      await prefs.setStringList('chatNames', chatNames);
    }
    await prefs.setStringList(chat.groupName, chat.messages);
  }

  void _showCreateChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Crear nuevo grupo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSubject = newValue!;
                      });
                    },
                    items: ['Calculo I', 'Calculo II', 'Calculo III', 'Ec. Diferenciales'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Seleccione la materia',
                    ),
                  ),
                  DropdownButtonFormField<int>(
                    value: _selectedStudentCount,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStudentCount = newValue!;
                      });
                    },
                    items: List.generate(6, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value estudiantes'),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Cantidad de estudiantes',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _createChat(context, _selectedSubject, _selectedStudentCount);
                  },
                  child: Text('Crear'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createChat(BuildContext context, String subject, int participants) {
    List<String> messages = [];
    Chat newChat = Chat('$subject - Grupo $participants', messages);
    setState(() {
      _chats.add(newChat);
    });
    _saveChat(newChat);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(chat: newChat)),
    );
  }

  void _deleteChat(Chat chat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chats.remove(chat);
    });
    List<String> chatNames = prefs.getStringList('chatNames') ?? [];
    chatNames.remove(chat.groupName);
    await prefs.setStringList('chatNames', chatNames);
    await prefs.remove(chat.groupName);
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
                // Navigate to profile page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              child: const Text(
                'Ver perfil',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to request menu page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              child: const Text(
                'Menú de solicitudes',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showCreateChatDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              child: const Text(
                'Crear grupo',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_chats[index].groupName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(chat: _chats[index])),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteChat(_chats[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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

class Chat {
  final String groupName;
  final List<String> messages;

  Chat(this.groupName, this.messages);
}

class ChatScreen extends StatefulWidget {
  final Chat chat;

  ChatScreen({required this.chat});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.chat.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.chat.messages[index]),
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
      widget.chat.messages.add(message);
      _messageController.clear();
    });
    await _saveMessages(widget.chat);
  }

  Future<void> _saveMessages(Chat chat) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(chat.groupName, chat.messages);
    }
}