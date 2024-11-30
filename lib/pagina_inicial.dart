import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendario.dart';
import 'perfil.dart';
import 'adicionar_atividade.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  late String nome = 'Usuário'; // Nome padrão caso não seja encontrado nos SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Carregar o nome do usuário ao inicializar
  }

  // Método para carregar o nome do SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('user_name') ?? 'Usuário';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(181, 33, 226, 1),
        elevation: 10,
        shadowColor: Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        toolbarHeight: 170,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajusta o espaçamento
          children: <Widget>[
            // Coloca o "Olá," e o nome do usuário em uma coluna
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Olá,', // Texto fixo
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  nome, // Nome do usuário
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Ícone de perfil
            IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 70,
              ),
              onPressed: () {
                // Ação do botão (opcional)
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            // Voltar para a tela de login
            Navigator.pop(context);
          },
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220, minHeight: 56.0),
        child: Column(
          children: [
            // Texto fixo
           const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft, // Alinha à esquerda
                child: Text(
                  'Atividades',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // Lista rolável
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Album'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Album'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone'),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TelaAtividade(),
              ),
            );
          }, child: const Icon(Icons.add),
        ),

      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0: // Índice do botão "Home"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaginaInicial()),
              );
              break;
            case 1: // Índice do botão "Calendário"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgendaPage()),
              );
              break;
            case 2: // Índice do botão "Perfil"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PerfilPage()),
              );
             break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
