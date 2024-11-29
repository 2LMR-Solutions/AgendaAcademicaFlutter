import 'package:flutter/material.dart';
import 'pagina_inicial.dart';
import 'calendario.dart';


class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          'Bem-vindo a tela de perfil!',
          style: TextStyle(fontSize: 24),
        ),
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
